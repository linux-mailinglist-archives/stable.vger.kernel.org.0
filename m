Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693A377473
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 18:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhEHWwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 18:52:43 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B7C061574;
        Sat,  8 May 2021 15:51:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l14so12785183wrx.5;
        Sat, 08 May 2021 15:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xVc9dRZsgvs4n/02bbmyB4h/4t5bj1yC9/RSdMZKmCo=;
        b=ragpnl+O+hP2KQrCWOhOh8nNvnrdcV7nvPjy9pQiC1Hdy6mOipn3sCQniDEfK2MHY4
         GNykMxjjffZNt8cxesDEGJyPpSzbfFetYyNydcpvBbP2YOLTppPxKK4iJiTCKYJk2hV9
         QRegYao/MXU2jp7VW4PzTQCRHR/ufIBt9+sy3LrlmkDcdMfVo4XW0XCdFwdS4aYw6sRp
         i4oVsIMY2g3+Tlkxk4l8P1Dl/UGr0vP2pGfTWxrg0YNYGmL6oaaKTjwIYH9j/USLPN2+
         GuCK37tTxdvbzBqdQs5rB7IXmXmpeQPiOtdlsapf5e9xOIeAxjCXORwiVC8wWx/y2SaR
         gpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVc9dRZsgvs4n/02bbmyB4h/4t5bj1yC9/RSdMZKmCo=;
        b=BmNkui8IF2J9GcmKMXloBQRMZbxg9kdK/ucHao8wXSXU0QWtLejZmF8zP1SIPjGcVq
         pQZm7BiduReyWEKS9dYMHCOp0Ou2u5SALJCMta3seNyD6FVBQSoShv74M0xk8b2Q0m41
         wNS6vqLWW/40/rj9TM6NrfEH78TsYHU53Km/eHzp3epM/S964QGe026CJjj1/yw9TyKv
         sK+C/VLGvkAGLX11IjQSjNF+1eIV21baTERm16k3sErM1MaScfV4s/b2k+EDOzoFnsv7
         tSb5CSG6Uj3unYSF9i+DnhxGSz3ATruPxf0KrcbP00vzIP83T2/2RSbgvI4TNX/hkIr2
         lbag==
X-Gm-Message-State: AOAM530FSlXGSCQs27KiXNlkLx/5OF9ZTLSecn3va+oqZbzFcY8kQCjI
        liwRRovLgzXecUfjzH+HPng=
X-Google-Smtp-Source: ABdhPJzRZH/h0kkla7FXjH96P2seItCK+KWON1Bqv5c7f7TcnrY33mdRUIdZEevUwoRzqEl+fvajSA==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr17550465wrp.274.1620514300120;
        Sat, 08 May 2021 15:51:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id q12sm16221130wrx.17.2021.05.08.15.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:51:39 -0700 (PDT)
Date:   Sun, 9 May 2021 00:51:20 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Message-ID: <YJcV6I6yYt5zIsXQ@Ansuel-xps.localdomain>
References: <20210508175537.202-1-ansuelsmth@gmail.com>
 <20210508185043.GF1336@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508185043.GF1336@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 07:50:44PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, May 08, 2021 at 07:55:35PM +0200, Ansuel Smith wrote:
> > Ipq8064 SoC requires larger IO_SPACE_LIMIT or second and third pci port
> > fails to register the IO addresses and connected device doesn't work.
> > 
> > Cc: <stable@vger.kernel.org> # 4.9+
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> I don't see any consideration of whether this increase results in any
> clashes with any other related areas. Also, there is no update of the
> memory layout documentation.
> 
> The memory layout documentation says:
> 
> =============== =============== ===============================================
> Start           End             Use
> =============== =============== ===============================================
> fee00000        feffffff        Mapping of PCI I/O space. This is a static
>                                 mapping within the vmalloc space.
> 
> which means there's a maximum of 0x001fffff available. You are
> increasing it's size from 0x000fffff to 0x00ffffff. This means it
> expands from 0xfee00000 through to 0xffdfffff.
> 
> This conflicts with these entries:
> 
> ffc80000        ffefffff        Fixmap mapping region.  Addresses provided
>                                 by fix_to_virt() will be located here.
> 
> ffc00000        ffc7ffff        Guard region
> 
> ff800000        ffbfffff        Permanent, fixed read-only mapping of the
>                                 firmware provided DT blob
> 
> So, I have no option but to NAK this change. Sorry.
> 
> You can find this documentation in the "Documentation" subdirectory.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Hi,
Thanks a lot for the review and sorry for the mess. Just to make sure I
don't push a very wrong patch another time. ipq8064 require 0x300000 of
IO space if all 3 lines are used. From what I can read in the
documentation, the PCI I/O mapping section does have space and can be
expanded to ff0fffff without causing collision. So I have to update that
part and the IO_LIMIT to 0x2fffff. Tell me if I'm completely wrong and
again, thanks for the review.

