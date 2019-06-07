Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECC3928B
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFGQxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:53:39 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:44313 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbfFGQxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:53:39 -0400
Received: by mail-qt1-f172.google.com with SMTP id x47so3016024qtk.11
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 09:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hbP4NV39kfwqjrM2uVAjAMMSDLVSDPZSh63Bx7Di41A=;
        b=SedHDblfYrrUma4FlQdqKB/gELJZG1KOj+Ttw2tWF6B/MVKt+8XBlPva9dl/QGS2sK
         JBqBOSCTUC0rzvk8jQ9OKU0oVy8enAgclmWltEvUP8vXzAmM5uF+gDtAFCQesUfTbIu4
         QCfPq92pa7wuFnRX9dax2gLTHAAGsCZQGjoW0TFT+xKUIkioPOOjqUvX+1SgxpReQ5BL
         QbArLLMLp7L6Sv5Ru6TDbSHWkwpnY+SABDWSd4bl/1M/AwS07+ebfUB4/6hYVLDLfOfu
         RCvZXawiBKVlvNBJ9+UwTGyX1+Lr7B60cyo5UUwDedalFdo5rncMXFSvRXzVcnoqbIyh
         d2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hbP4NV39kfwqjrM2uVAjAMMSDLVSDPZSh63Bx7Di41A=;
        b=HK8aEOvtAusIEWA1XNlIvGtEQlrCWk+9kfsy9NTJucGQJXxVytububGAggAH7QJHce
         VyZvCTXYsrjAM/ByrBOfw7ibdWsyOtym/vSb7eYKr/1N0N8QLLNjA/UAu5SxKMoZBoSb
         KNrjADtfIXF8Hi7Pk/ECkafLAq3TAK4k4NwsN+/3Kja8iJEx9vATm+ms8Rpxgb1MudFw
         bC+BIHy+DTNH2BbQ9AzPawz5pVZz6R9wGBCiqlNQ211Nm/uDFpwYtWTg1ZbzdjLe2bbQ
         garKonMP8aU475NEbS633lWyXcgO9TfCZ+VuVgNvcFUhg/91PWgmwcmwzuh7waX7R0ch
         Plbg==
X-Gm-Message-State: APjAAAU9sHjKk+712M8QV8/j1R0m2/e8duaeJxkC6kplr+IieKSyHDXh
        tWgm3Q9x058h0w+X2TTJLP5UhmCYSwf1MA==
X-Google-Smtp-Source: APXvYqzhzJQ4ETZ7wJZxSTF/BgzunvU6O7pRFTiYvUpBHGu+wQzrfYbo2Ob9g2EpJmCwGTlM0k1nQg==
X-Received: by 2002:aed:2fe7:: with SMTP id m94mr45205851qtd.191.1559926418598;
        Fri, 07 Jun 2019 09:53:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id 39sm1490220qtx.71.2019.06.07.09.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Jun 2019 09:53:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hZI7V-0005qA-Qh; Fri, 07 Jun 2019 13:53:37 -0300
Date:   Fri, 7 Jun 2019 13:53:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do
 not have a port number
Message-ID: <20190607165337.GB22304@ziepe.ca>
References: <20190529163831.138926-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529163831.138926-1-bvanassche@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 09:38:31AM -0700, Bart Van Assche wrote:
> The function srp_parse_in() is used both for parsing source address
> specifications and for target address specifications. Target addresses
> must have a port number. Having to specify a port number for source
> addresses is inconvenient. Make sure that srp_parse_in() supports again
> parsing addresses with no port number.
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)

Applied to for-next, thanks

Jason
