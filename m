Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9F95654D3
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiGDMSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiGDMRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F78F12769
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F5B611D0
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CC5C341D0
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:17:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="o4jYTQR1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656937021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3oitsPG/dT1jGMKyq/8KPFQ2DlayFUdEK5e7GGvm90A=;
        b=o4jYTQR152PxWYOZs3QU6JgOlYby9MFeD6/nVXoVyExNooU5nRbITIhVMJf8Hfhuq9l5rv
        59VVzWV2//Rf/TsncxMkJI2d0r2kCm5ZIOmyEp339srEC1NOqiBMso1ADsK2mf4ISKgoPO
        WlxHoPyEEHPw5OoNRePMgLajoUsbAQQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 51d2dd80 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 4 Jul 2022 12:17:01 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id a7so5488311ilj.2
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 05:17:01 -0700 (PDT)
X-Gm-Message-State: AJIora+XDr9SRG5R1TZ6nSJ2kzfQQv3BIargSNBY3dWR+49Oc/YG9L0x
        6Okw3ROdzdBw+PjhSvcQmOVvG2FCV0I8SmBkly4=
X-Google-Smtp-Source: AGRyM1ujDXWiOFoAN229B0z4MWNuDBO0Hc0aQW8W7CiSl2vCIrQb94E9YcrU6DiMWj52pOtR25Oq1+SRFrAwEN4tnL4=
X-Received: by 2002:a92:c26e:0:b0:2da:be5e:69d9 with SMTP id
 h14-20020a92c26e000000b002dabe5e69d9mr16556397ild.42.1656937020101; Mon, 04
 Jul 2022 05:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <165692023121374@kroah.com> <ecdc97781aa01304ea998d9fe9e5391d@linux.ibm.com>
In-Reply-To: <ecdc97781aa01304ea998d9fe9e5391d@linux.ibm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 4 Jul 2022 14:16:49 +0200
X-Gmail-Original-Message-ID: <CAHmME9pDn2_coykrD6xdDG7Stzz93QBNVqOidh7v9OYCTp7R8g@mail.gmail.com>
Message-ID: <CAHmME9pDn2_coykrD6xdDG7Stzz93QBNVqOidh7v9OYCTp7R8g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] s390/archrandom: simplify back to earlier
 design and" failed to apply to 5.10-stable tree
To:     freude@linux.ibm.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, ifranzki@linux.ibm.com,
        jchrist@linux.ibm.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Harald,

On Mon, Jul 4, 2022 at 2:15 PM Harald Freudenberger
<freude@linux.ibm.com> wrote:
> Yes, that's understandable. And I think, there is no need to backport
> this to kernels <= 5.10.

1) I did the backport already.
2) The RNG from Linus' tree has been backported to 4.9, making the
init-time fix just as necessary.

Jason
