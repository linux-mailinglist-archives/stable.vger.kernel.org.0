Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F10F2F74
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 14:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388388AbfKGNdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 08:33:43 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34273 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388271AbfKGNdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 08:33:43 -0500
Received: by mail-lf1-f67.google.com with SMTP id f5so1635098lfp.1;
        Thu, 07 Nov 2019 05:33:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DAJAgFyN58cHvYPVd/mVHD5c2xckpaUqCtwazPHzm+U=;
        b=RFEyCz/Bi3kPXQ3f8TdoKpFr8hOPoYu4RPoyYo6Jg32xkfOMd7QGBeKtC/CyMyqTwm
         l78I7p5ncvqOc8dqqK8YTAkXn61EK/Ps8KPO8mYBnJV3u1ORfmjfxHI47Yt7xkR3IBBN
         2PGWr0Ts3U/2RfNp9V1EPlko/GFVWrA+IjPZw1hA3VAJGV7MeOTdVZ4BAOXmY+ZUQiDw
         PhgGsTpRULTjQtZlO+ApbamXm4Jt3Ija5mI1uUEJIl1ovWoKaGyuYriZHBL6pAJG/O4P
         dwTVhfhHF+T0cLiA3XkPVIlx/xbPrlj0j2YbMbZdcoqeaEb/JewA9GFHmAlAJK43ckcB
         le6g==
X-Gm-Message-State: APjAAAXi0J7EagXLAP/ytqDNZntxQyAe4JgTcW4gonj9u5HhAqwqCfVZ
        Ef4IvmsEOk5yd06OrEJl0OM=
X-Google-Smtp-Source: APXvYqw/739omEVr/CNEKy2TMwguM449blxmzi6x5pLpDi3gLStVyMgaNzVBfeSYxhlNbBVGfz/Irg==
X-Received: by 2002:ac2:5f01:: with SMTP id 1mr2452877lfq.147.1573133621273;
        Thu, 07 Nov 2019 05:33:41 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id u12sm984154lji.50.2019.11.07.05.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:33:40 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iShuv-0000gu-R8; Thu, 07 Nov 2019 14:33:41 +0100
Date:   Thu, 7 Nov 2019 14:33:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     johan@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: option: add support for DW5821e with eSIM
 support
Message-ID: <20191107133341.GB8732@localhost>
References: <20191107105508.1010716-1-aleksander@aleksander.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107105508.1010716-1-aleksander@aleksander.es>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 11:55:08AM +0100, Aleksander Morgado wrote:
> The device exposes AT, NMEA and DIAG ports in both USB configurations.
> Exactly same layout as the default DW5821e module, just a different
> vid/pid.
> 
> P:  Vendor=413c ProdID=81e0 Rev=03.18
> S:  Manufacturer=Dell Inc.
> S:  Product=DW5821e-eSIM Snapdragon X20 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> 
> P:  Vendor=413c ProdID=81e0 Rev=03.18
> S:  Manufacturer=Dell Inc.
> S:  Product=DW5821e-eSIM Snapdragon X20 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 7 Cfg#= 2 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
> I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> I:  If#=0x6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> 
> Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
> Cc: stable <stable@vger.kernel.org>

Applied for -next, thanks.

Johan
