Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9124713A7F0
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 12:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgANLIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 06:08:02 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33009 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgANLIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 06:08:01 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so9517576lfl.0;
        Tue, 14 Jan 2020 03:08:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfZydivwfpsS9eSFFmwuHqFctO21HupiJd+0/1Yj/aM=;
        b=ulLMmfkzSabw5x+jFstssnAbT3pPlGUQoJCp+07XQ71B1R9qyfjzYirS7MFznc4i4n
         CAdO15VAEhyKk/ASGyVtdMo0gSpSkW8Uz7ODcOZaAO2T6K+e5H1IxqIshu8lSVs87MMV
         S9lDdDsVqlxxZ6ZTpXMtH1SJaGHlvIgU0I1IEyP17tG2syrgG7V2o87v5GJIuCA5DxRH
         KxlSzdqUL3d4sO3qe67oTi1Z9ZoJ1ggLJDydRedbiQktIuUGidJYzMhq4G9huUVsI199
         8sZCgnJDgFPyBlxbcLTGJ0XhiuRPEL3cJ+Qy0bPHn1aoVmNFa967wG5x2DAQydmf1hCm
         79mg==
X-Gm-Message-State: APjAAAVtKJbXgyoezQwO8XCCZJw6+ugkZBqvNpnwLYMyNeOP5xF9zLhv
        ZvT3lZ8RQTkV+zCPNNAIwogwjf8m
X-Google-Smtp-Source: APXvYqyeY0JmYJPp+WsuWZKtBdtzIUB0Hcp9sQSnT/SENGAhSj3t9Xh53Hjs9siinjvGFA7KOUbY0w==
X-Received: by 2002:a05:6512:41b:: with SMTP id u27mr1316895lfk.164.1579000079727;
        Tue, 14 Jan 2020 03:07:59 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 204sm7123754lfj.47.2020.01.14.03.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 03:07:59 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1irK3D-00016I-2i; Tue, 14 Jan 2020 12:07:59 +0100
Date:   Tue, 14 Jan 2020 12:07:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Martin Jansen <martin.jansen@opticon.com>
Subject: Re: [PATCH] USB: serial: opticon: fix control-message timeouts
Message-ID: <20200114110759.GG2301@localhost>
References: <20200113172213.30869-1-johan@kernel.org>
 <20200113182546.GF411698@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113182546.GF411698@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 07:25:46PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 13, 2020 at 06:22:13PM +0100, Johan Hovold wrote:
> > The driver was issuing synchronous uninterruptible control requests
> > without using a timeout. This could lead to the driver hanging
> > on open() or tiocmset() due to a malfunctioning (or malicious) device
> > until the device is physically disconnected.
> > 
> > The USB upper limit of five seconds per request should be more than
> > enough.
> > 
> > Fixes: 309a057932ab ("USB: opticon: add rts and cts support")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.39
> > Cc: Martin Jansen <martin.jansen@opticon.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing these. This one; now applied.

Johan
