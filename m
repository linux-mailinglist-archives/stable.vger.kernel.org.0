Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD981B68E
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 14:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfEMM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 08:59:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36083 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbfEMM7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 08:59:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so8992140lfl.3;
        Mon, 13 May 2019 05:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v+PzpQv27VIzzclqZ9CVDdzIa7vWf5SvgTiViQhIq5o=;
        b=O3kGzLfijr9WiHSGXOrrZfVOEfR5pMLHrDjOzhhubYmtJIsG4RMs+U5NBRSTfSvRIr
         tEChjxExg0usvbrot4BlmHWG6RqTXuthp9rhegbd1bPxM4nPMMO3uSSaYQ2MYBx2dugv
         UhAWY9uPGwk56Ftik6P5B2Dk4HDgGBAPd1mB5+C58ZN/UK5X9Tod6dNNpFof5ltlVvTS
         WVFH+k+QkNXYli9SF+xObubN1xOqQlP0XxzJKgq1iPYyNrAqvZ/lijRx7jldj/oMCeqY
         u7MOe1bgwddB3o7NIJ6E3xDHUp6MkCumQuG1V/Y+XD9klFEVjO0leKrHLWYpZUU2iB53
         4oww==
X-Gm-Message-State: APjAAAWlRE5EBKb12/9mapIJ3l29ZRyunffWp1fU6YI6gXTyVuNTWd45
        cOxVBLUafsBwDSiR32dDJSseABj1
X-Google-Smtp-Source: APXvYqzgvBoUtHRtFmLUMDMBiABvYTn4xNlvdEqDFxi7yt6Yav1nx6u7H5yiGn/LeWJMx+ibH920yQ==
X-Received: by 2002:a19:4811:: with SMTP id v17mr7511695lfa.10.1557752353878;
        Mon, 13 May 2019 05:59:13 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id h11sm1150611lfh.8.2019.05.13.05.59.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 05:59:12 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hQAXt-0001rV-Nc; Mon, 13 May 2019 14:59:09 +0200
Date:   Mon, 13 May 2019 14:59:09 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] USB: serial: fix unthrottle races
Message-ID: <20190513125909.GC9651@localhost>
References: <20190425160540.10036-1-johan@kernel.org>
 <20190425160540.10036-2-johan@kernel.org>
 <20190513104339.GA9651@localhost>
 <20190513105606.GA21346@kroah.com>
 <20190513114601.GB9651@localhost>
 <20190513125131.GA7541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513125131.GA7541@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 02:51:31PM +0200, Greg Kroah-Hartman wrote:
> On Mon, May 13, 2019 at 01:46:01PM +0200, Johan Hovold wrote:

> > Thanks. The issue has been there since v3.3 so I guess you could queue
> > it for all stable trees.
> 
> Doesn't apply cleanly for 4.4.y or 3.18.y, so if it's really worth
> adding there (and I kind of doubt it), I would need a backport :)

Ah ok, just wasn't sure why you chose 4.9+.

Johan
