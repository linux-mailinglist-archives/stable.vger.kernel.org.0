Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E355131F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbiFTIqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbiFTIqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:46:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB80E62CD
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:46:13 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id c2so16161455lfk.0
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1whDq3La3S3wJgVVVKM0qwBvOFvGeuXT7fA+q99OCQ=;
        b=V239pbMCKN/cnAMGjzY9mC+X1m2kO5EGZR1i3QRsCdvpvMkEePnmREh2fw1V9HWtNI
         dF1fHkQ7x5SHHNQASACh//g6S7GX+3eSyCc34hFKHOqh6CBYpE7nTrPAA2R6welxzv/2
         59QyhkrLs90EaXvnYRuguAwASu4IqOfkUOdoHW8461Zi8phndwADahfZ8OIepPZ7i6GL
         d2nAiPODnHhxmKksaEnOcM2IhjS/IRcLZY4bUeiZqR070rLf9lSovbUzWBdWgKKaDXmt
         keILO88w74s73NA22xJmnVnUXIgjIB3FBMkx47nSifO6ZsNtCu1H/dkXIkHRrP95TLF3
         ZKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1whDq3La3S3wJgVVVKM0qwBvOFvGeuXT7fA+q99OCQ=;
        b=CyG8+El8oRnIR0ioGCawrYqfXzDcr3uKMVqtJc+JHrE3+wpFGnUvBpeO2mpORIj0Bd
         76jWsxj1iILLpgoe5Fe024YjnbAfnD8aRcq/Au36y8HMu5um+iNhdvHjnI4hvZxqrii8
         1qr7o/0qaJdRmQ8OU0rtFvxdd/nc8rRYiTJeFS5pS3/w5sox4bM5F3nFVx1e4EfApdKk
         irLbscT4mBOlXSlGqHLgu8ECsa1JdulQlldwnoEiScmPAOQshojy6XhO7OIYGLtWW18D
         7RGlJFmYYnhwo9tY+99KjK7be2fWeaU+V7hOYUyuFoVNfiI4Ni2toNwR8AaMeKKa2r5O
         yO+A==
X-Gm-Message-State: AJIora91+LOp0FDUEBNPHcCdub5anqQhkxTJQrvscas6guMVc4EAe7I4
        DyGyYmRmUkH6XpJgf6xZiZ2J+AeBXi5AJgRmMHDGPTi3
X-Google-Smtp-Source: AGRyM1tLLMGw5ieWhJI63skLfDlhpysorYgbKd07rLRc7i/FCpQ38Ia2DihLPsWSqJRLR5Oa0d3t7Xsm/4l4w7LtM2A=
X-Received: by 2002:a05:6512:22d4:b0:47f:706b:23b5 with SMTP id
 g20-20020a05651222d400b0047f706b23b5mr1869776lfu.44.1655714770838; Mon, 20
 Jun 2022 01:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAM3i8OEGrux+ku7hL20oGO10f=CDLkpcg3wH6hRbheEdacWnfw@mail.gmail.com>
 <CAM3i8OF1mC21wzwfsvhQTK7PPa0myCwftyhA9U1r7HR_0Q3fLQ@mail.gmail.com>
In-Reply-To: <CAM3i8OF1mC21wzwfsvhQTK7PPa0myCwftyhA9U1r7HR_0Q3fLQ@mail.gmail.com>
From:   "Ernesto Vigano'" <lanciadelsole@gmail.com>
Date:   Mon, 20 Jun 2022 10:45:59 +0200
Message-ID: <CAM3i8OFjvOkLGELkrKEo3B7x0hP=uPrYaPL05=0WXygvYJNZCQ@mail.gmail.com>
Subject: Fwd: question on driver for phy dp83td510e
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, o.rempel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I see that some weeks ago a driver for phy dp83td510e from TI
(https://www.ti.com/product/DP83TD510E).
I see that it's really different from the Linux driver supplied by TI
on its official repo
https://git.ti.com/gitweb?p=ti-analog-linux-kernel/dmurphy-analog.git;a=commit;h=fefa908e4e3262455a0cec08f3bb7161d7792d02
As an example, TI writes some undocumented register for version 1.0 of the PHY.

Should I forget about the TI driver?
Or is there something that should be integrated in
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/dp83td510.c
?

Thanks
