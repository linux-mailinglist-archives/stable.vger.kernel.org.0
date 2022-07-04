Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F41C5654FE
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiGDMSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiGDMSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:18:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D6011C3C
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F60960EC2
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67537C341C7
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:17:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q1nKVODY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656937066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qsO2bTq21X72DR6sNVXLXV82OAvu8O825qgjDiG0Tzw=;
        b=Q1nKVODYG0knVpSLF+xHF2iBeiLWOQaCbwcA9rBufEULXC48mTdI9nOzKzm3nnE8LGmo7r
        gqueZo+wn6b/x9lNe8iJ2P2TCacVwBAvFXmypYBqdTVoxY+y0+FzYF+MDCiI6RSWj96Idg
        sqYnHEjq3nKEapUqXN5A1lv/4yO3yY8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08828fee (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 4 Jul 2022 12:17:45 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id r133so8489506iod.3
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 05:17:45 -0700 (PDT)
X-Gm-Message-State: AJIora9A+LX+LjT7aqjeKbyd+OCtcxXfUiIpLMwk2vcTOlYCaG6aE4Ey
        T5BvF/sv59x1FZEQapIALs1yxfLipF9W+eEFInA=
X-Google-Smtp-Source: AGRyM1sQ3ZCqBIIWV64AUaDpiZBRXp0/K9wOUjmACjtuM8hrZNOj2cUHMCcCs3Pdli8vWqLurpCvzqimkAcKHmHvuZY=
X-Received: by 2002:a05:6638:19a:b0:33c:8ce3:8346 with SMTP id
 a26-20020a056638019a00b0033c8ce38346mr18711833jaq.204.1656937064935; Mon, 04
 Jul 2022 05:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <16569202321345@kroah.com> <175bf52900b125d6f173ab344c56babb@linux.ibm.com>
In-Reply-To: <175bf52900b125d6f173ab344c56babb@linux.ibm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 4 Jul 2022 14:17:34 +0200
X-Gmail-Original-Message-ID: <CAHmME9rvHV0D8_Dwzi4dM0dDXNgpPGhQnMzdka_-iG+bzcMdKw@mail.gmail.com>
Message-ID: <CAHmME9rvHV0D8_Dwzi4dM0dDXNgpPGhQnMzdka_-iG+bzcMdKw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] s390/archrandom: simplify back to earlier
 design and" failed to apply to 5.4-stable tree
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

On Mon, Jul 4, 2022 at 2:16 PM Harald Freudenberger
<freude@linux.ibm.com> wrote:
> Fine with me. Skip this patch for kernels <= 5.10.

As I mentioned in the other email I just sent,

1) I did the backport already.
2) The RNG from Linus' tree has been backported to 4.9, making the
init-time fix just as necessary.

Jason
