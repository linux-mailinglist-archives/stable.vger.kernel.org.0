Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5E66198A
	for <lists+stable@lfdr.de>; Sun,  8 Jan 2023 21:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjAHUwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 15:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjAHUwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 15:52:15 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A82D101DC;
        Sun,  8 Jan 2023 12:52:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x10so6953458edd.10;
        Sun, 08 Jan 2023 12:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/W1ZH7okdp3bC5pjHi5v6nQazt9WUGWbkW62SJcD8hQ=;
        b=CZSi5VCe45fYPvoueF3Xz9/2f8RQXo4zyAt34wYxgvnxVuDjBRRzHICHSsCVFL9qvD
         y0k+0LPoVdQjSsrczYbF/yitqgcOmTgTpEhjZtjt3K0/vdqY5X6LE/vA8Fahyg8LBmDb
         JgHj7ZOPWTu5jVphQgd2X6yMgiB49QeVi3N0e+QyysPEGlgHC2MSxjtVjIIvUA/FAPRj
         S2/zFCg6UTJiLPOnA34xzSUTpD7z1bpfhFvFx175/mX+wgOxWh3adhrMU+ehQ0Yfx+qm
         4zBi2y/2PuqdbZfQq8N2IMW2hGoNSPkVsIURkr3reDhJWPsvh63lvhO3Fate3WhzcCbZ
         oqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/W1ZH7okdp3bC5pjHi5v6nQazt9WUGWbkW62SJcD8hQ=;
        b=pRmlAb6i0zyxBrV0PcZcZmTaEFcVY0CdajtFthMXJYou2gegsYIqCn5mhYB+0gVvAq
         IuSriOLFqVgAxAQknxlbWDb/Uj7PBZlbyzVhTjeob5A/jMh9yFlpTcMWb7ewDIHXluI9
         p7tGMFtbWgkm9wH9SVn22oimTN5SxTyygiDKV9M/ur422O5bMcNzPtavoYmAW3PFCS5G
         bAKqhkrcGpCmj8jaMcIPgFl7CX14JA43SdAHXe0ISV7onoBpiTs5KswMFGPCVaKDBa8W
         ivwch7gboWh7ZBH1GA8vBTK0YoKuq9X/RycL3xJ9jMGY8Wo+3UABHbEd8HFhaTMktvua
         iHFw==
X-Gm-Message-State: AFqh2koORUSgiOiUKxVAxOFhEfnDiTocahbcdCYI23X53mEnbEm9N4J4
        qThAfPAGts/R8ZtW1Uzbnu4=
X-Google-Smtp-Source: AMrXdXthkxdR5S3Vx/C5pVKc8nmwQsnxhLxbv5FwkjZ/fyeqvLUsh+ZvJxXis6Q2Ef7PtQwkRWND5A==
X-Received: by 2002:a05:6402:104d:b0:486:ac69:b9e4 with SMTP id e13-20020a056402104d00b00486ac69b9e4mr36935941edu.4.1673211133033;
        Sun, 08 Jan 2023 12:52:13 -0800 (PST)
Received: from jernej-laptop.localnet (82-149-19-102.dynamic.telemach.net. [82.149.19.102])
        by smtp.gmail.com with ESMTPSA id k26-20020a508ada000000b00487fc51c532sm3016451edk.33.2023.01.08.12.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 12:52:12 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>
Cc:     Samuel Holland <samuel@sholland.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, stable@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 1/2] nvmem: sunxi_sid: Always use 32-bit MMIO reads
Date:   Sun, 08 Jan 2023 21:52:11 +0100
Message-ID: <5829449.MhkbZ0Pkbq@jernej-laptop>
In-Reply-To: <20230101183316.43642-2-samuel@sholland.org>
References: <20230101183316.43642-1-samuel@sholland.org>
 <20230101183316.43642-2-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dne nedelja, 01. januar 2023 ob 19:33:15 CET je Samuel Holland napisal(a):
> The SID SRAM on at least some SoCs (A64 and D1) returns different values
> when read with bus cycles narrower than 32 bits. This is not immediately
> obvious, because memcpy_fromio() uses word-size accesses as long as
> enough data is being copied.
> 
> The vendor driver always uses 32-bit MMIO reads, so do the same here.
> This is faster than the register-based method, which is currently used
> as a workaround on A64. And it fixes the values returned on D1, where
> the SRAM method was being used.
> 
> The special case for the last word is needed to maintain .word_size == 1
> for sysfs ABI compatibility, as noted previously in commit de2a3eaea552
> ("nvmem: sunxi_sid: Optimize register read-out method").
> 
> Cc: stable@vger.kernel.org
> Fixes: 07ae4fde9efa ("nvmem: sunxi_sid: Add support for D1 variant")
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej


