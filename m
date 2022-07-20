Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5F57B0AA
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238060AbiGTGAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238202AbiGTGAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:00:50 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19295C340
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 23:00:44 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-f2a4c51c45so34863578fac.9
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 23:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=GdWiTqPNpRvrIn/Cn1CxOA73dPIXQQ7hC8GlLECuAKk=;
        b=C1F8GZi//ietuhNpm/thbGg0wgeMK39yhvDEndF3jHlwAPNOTH0Ftq1JvqfyOkc3xJ
         kOrn51JHI1J61ogN3EoGAxdg8mLEExovUIs91yPoH2IgXyIaPHKvtDgwrAVkVkrdMEQA
         5lnMuVsO5SxbM3qSxvsm87gLxiw5EYHCudC47Cub8YSWuEu9WKfTnUjs4KLd5NICAJZ8
         LOMbquCBF6kLST77rhMas9pAwpariBwGoYjWgsJ/ABJx0fa+xDagU0sEmebKyRZUC4+k
         KAYw6hTUtGfNdT8LdXVdK7Dde3uoFMa+4lFkpizUolvgAYwEYlNHFIclyVQHl4eRZKyr
         24iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=GdWiTqPNpRvrIn/Cn1CxOA73dPIXQQ7hC8GlLECuAKk=;
        b=Vt56o1D/GfTwPNvlSU+R4lu139Uvl7qh0QqP3dmHpznN/9Y3TiqGYvHjh+TF3t/Bp9
         t+sZK1bo6s3kccziMlMfvVZpEjU5l/JZZ97NVAs5LjYfOp3x3GTfioskXWmzZfuPRzlA
         QsswnVotMNe3S1pG5XTD/V1NXXHzH4IEH+4aIhCx80Uci4XNiWrT5GmbT7udK3ZbASpk
         c6GbSWXsnzxI6H1OMO/JZPLp5AEt/0mjH3izu6Ng5olK583OFmQODemo2w02Hpmq49uw
         P23+8EYQU5guyHU/M+PVa/DjRcqoEeXQLpCHzLrH1QUpZjYwuHEFFQHz4hmY28rSkQxi
         MQdA==
X-Gm-Message-State: AJIora/6lKVfUCzMa3IkdhFLZ25hZpVDcWJc6HkW9toyI/FDIYZvTgS+
        ZmRDzb90xhq67yb5UyG4yEs52Rkl8IEMIliZrg87W4nH
X-Google-Smtp-Source: AGRyM1spNfWCLo1SZ++RT7SPwlag4vAXVw6/GE1UfeUydbfjdoMF8SCdpDkB9hjIiDL9DfesjoSVhjromPhTd6LUuys=
X-Received: by 2002:a05:6870:6195:b0:100:ee8a:ce86 with SMTP id
 a21-20020a056870619500b00100ee8ace86mr1669737oah.40.1658296843660; Tue, 19
 Jul 2022 23:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220720054341.542391-1-fabio.porcedda@gmail.com>
In-Reply-To: <20220720054341.542391-1-fabio.porcedda@gmail.com>
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Wed, 20 Jul 2022 08:00:32 +0200
Message-ID: <CAHkwnC9hajcQba_z=NBf-=yPUEEQJ0GTOf9kBWrfZ6H0SCqA8A@mail.gmail.com>
Subject: Re: [PATCH v3 5.18 0/2] Backport support for Telit FN980 v1 and FN990
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il giorno mer 20 lug 2022 alle ore 07:43 Fabio Porcedda
<fabio.porcedda@gmail.com> ha scritto:
>
> Hi,
> these two patches are the backport for 5.18.y of the following commits:
>
> commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
>     bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio
>
> commit 77fc41204734042861210b9d05338c9b8360affb
>     bus: mhi: host: pci_generic: add Telit FN990
>
> The cherry-pick of the original commits don't apply because the commit
> 89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
> on the PID, 2022-04-11) was not cherry-picked. Another solution is to
> cherry-pick those three commits all togheter.

Superseded by v4.

Best regards
-- 
Fabio Porcedda
