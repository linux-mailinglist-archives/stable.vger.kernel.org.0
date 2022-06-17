Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9D54F65E
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 13:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381694AbiFQLIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381591AbiFQLIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 07:08:48 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8F4522E1
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 04:08:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so2137680wmf.3
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 04:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=qvoWCJnyqHyNzMdzMw38BKuCMtOofa/9H+8rQFIdbio=;
        b=XxYSXMRdWtf0rvvPnS0HC5Ecu6obop1ypCDUrZXrApLoIqr4YGP4LJtetlyFBi5bAe
         9u+MbpT/akU0Olm0n4bkcI3byqJ7yTHCfNO6GKe0iCLWoSukuaSi4HfZX98PT23Eav5s
         Ftls/CvsxqtpwSe2vH4B+bRX14qwlPBaWV0K/xVO004sALeZBEpr267NpW7XNdaOIval
         zT0E5DqnP4hImp1G0e1oLvBQAr8Yv4BBcTAuw1XVMG/TwFNkT0ktAPUgWpCEilGLZ6gC
         9v9IpKnKGEr2QETvP7EYUqEx0YIwwcR+8Was9/Wi8YC8Q58IAq9I4J596721dKKrJzBK
         H6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qvoWCJnyqHyNzMdzMw38BKuCMtOofa/9H+8rQFIdbio=;
        b=NhnnA5JwRpXGym9B9yMiCh7CJQ+qtv8ybuwkLPFe7lbKk2jfMAnGG9VlMKqRNWjK+M
         TpQsJ5HHqvKMsvSYrLXBG1naCc/JAsVDkpC58H3rf+TbJCpDomKetV5ddsAdhte+fKW1
         ktqp3Q8H5Dhq/jV5rvoV+irtIzmGZ77LSZb2f7p+SUWelHLCBqL3WlnH19hvF/YarNgY
         k7H/0I9ZknK9g8eJYEhqS5urunMig09LexchoDsKvDvyUyponWktCC9JzU2C08EyeLhm
         vfvmTedonqt9v/Yr3mevJ/HItDnz1QJMexjHRYLhIAP6/hxxW+QWqPFvpmBSeLIlNjxo
         ocig==
X-Gm-Message-State: AOAM532Ex7jqKLWzEqY3sGB+cDdljvEZPoVOhI+YFlCgjpdH02ktdoWA
        iZ1/owwwI2gGpONgkmgjbOemuewCBbo=
X-Google-Smtp-Source: ABdhPJyOsEzPvUWfboFv+nEuFIjtAmERvu/lg+O3pTI0LPreJHp+fae/Vfpv810x30sZPsaNW+Q2/w==
X-Received: by 2002:a05:600c:1c8d:b0:39c:4db1:5595 with SMTP id k13-20020a05600c1c8d00b0039c4db15595mr20379007wms.175.1655464126528;
        Fri, 17 Jun 2022 04:08:46 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id z18-20020a5d6412000000b002117f872f81sm4257411wru.113.2022.06.17.04.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 04:08:45 -0700 (PDT)
Date:   Fri, 17 Jun 2022 12:08:43 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: patch request for 5.18-stable to fix gcc-12 build
Message-ID: <YqxguwkPJhyvKbRk@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

v5.18.y riscv builds fails with gcc-12. Can I please request to add the
following to the queue:

f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")

This is only for the config that fdsdk is using, I will start a full
allmodconfig to check if anything else is needed.


--
Regards
Sudip
