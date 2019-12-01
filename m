Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186AE10E1FB
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 14:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfLANEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 08:04:37 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41440 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfLANEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 08:04:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so341473ljc.8;
        Sun, 01 Dec 2019 05:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6oQ9pFt2y/HOgvjM6zb3KOxNIUI97tDsrOEUXJyqzuE=;
        b=CMuosajImF3ezinV9PCuKcQn6SrWQOG0xOc09ihAWLWLEh24CWrqa8XfmrAox++jMr
         ja57p1VN58T88nGgCMaNuHF2PqvSa9a6/ArMZwE6/CXTDARwHokA+2GbbEqI4ZTr7ylE
         IfcYdsyTY0p93hFGBasu8Z9aVMOlCOaEx5BBv0dGd69GEQ5CL9Y3Sq7JiBi2X5Dy+IR1
         8nikUEHLF7MKDRzf6/avyCp+sQOyGWPJAJd/70NU4vGBuEuJwrioDS4QAjWJQ2V1wOOb
         M8EHp9fXNHCScKT3ZUW3W6Cfu4lndy0g6/yVSYmGmvzazbsbFDpLnTJF6FhYR2h2tfCo
         5bjQ==
X-Gm-Message-State: APjAAAWoyT4y7g577I2YMGMMBQ7NjKAXi1xH8Bu8r8Yb3OHxRkmLj/Sr
        To3QSeV6J558yL9l7OmrkI0=
X-Google-Smtp-Source: APXvYqx64w8NIjl4a4DfQBwm2fcHd47pW5Yqi0KA2o7sRCfSt6UeE4zBCgl7nEZxvAaO8yeXH9nhSQ==
X-Received: by 2002:a2e:b4f6:: with SMTP id s22mr30841886ljm.218.1575205474691;
        Sun, 01 Dec 2019 05:04:34 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n19sm12926938lfl.85.2019.12.01.05.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 05:04:33 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1ibOtx-0001z4-Vl; Sun, 01 Dec 2019 14:04:38 +0100
Date:   Sun, 1 Dec 2019 14:04:37 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tilman Schmidt <tilman@imap.cc>, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: gigaset: fix general protection fault on
 probe
Message-ID: <20191201130437.GB23996@localhost>
References: <20191129101753.9721-2-johan@kernel.org>
 <20191201001505.964E72075A@mail.kernel.org>
 <7cfa2ada-d1ea-aafe-6ac1-f407e3bd558d@imap.cc>
 <20191201124156.GA3836284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201124156.GA3836284@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 01, 2019 at 01:41:56PM +0100, Greg Kroah-Hartman wrote:
> On Sun, Dec 01, 2019 at 01:30:42PM +0100, Tilman Schmidt wrote:
> > Hi Johan,
> > 
> > this is probably caused by the move of the driver to staging in
> > kernel release 5.3 half a year ago. If you want your patches to
> > apply to pre-5.3 stable releases you'll have to submit a version
> > with the paths changed from drivers/staging/isdn/gigaset to
> > drivers/isdn/gigaset.
> 
> That's trivial for me to do when they get added to the stable tree(s),
> no need to worry about it.

I'll be sending a v2 of this series shortly. Somehow I managed to
overlook usb_endpoint_is_bulk_in() and friends so patch 4/4 should no
longer be needed either.

Johan
