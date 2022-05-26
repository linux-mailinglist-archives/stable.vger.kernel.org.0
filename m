Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9410535247
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiEZQlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 12:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiEZQlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 12:41:49 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA5BF18;
        Thu, 26 May 2022 09:41:49 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c15-20020a9d684f000000b0060b097c71ecso1297917oto.10;
        Thu, 26 May 2022 09:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=fAnwqjpJIA2T/ZTyHUwVx0u4aY+zBTaNXhuFNK0GJX4=;
        b=oDCxbRHKqlg5pawaIgeC9JNhr/1Qn5H5aEXa3nxQ5ydNzOm1cT5JCbDy3YuIqMJ4CD
         vUbQbJjzsINtfQr+KA9Kyq+Wxlswpycu8dLYxu27njXKxcZ+zc2KAV6raYgiafV74GfM
         M+vYsxpgMLivrv3v3mX6s9IBTa/K9A9jFo+O0Q+3NAKb7Hap6g1l/2UUmCLZ4Lx110+n
         lls3TQ2WjX6oEk4Bd6hWXrxFcTFy1z02u8NG7YhLsJqwYpWESkn2NZidKC5cSxwX/J9z
         Djb1Znn7NC6Xjm4v2d20F8V24jyl+EFxtYGJYRP22B3PiR7PHGp/1XBFRKboAZkMO8KT
         FlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=fAnwqjpJIA2T/ZTyHUwVx0u4aY+zBTaNXhuFNK0GJX4=;
        b=KKm3phkMm9wpO30sms6Alkhaz20ZlMx2h4TaetKD9tFiVg0H+lJzgqNLD3u+GTLgzs
         lxeS7750jDgu2NYiLd9I5iETp8Qw5iL3f6Kci2En5qIKy6EB/svxOYVcdP/KxeQUzJMH
         hTvKiYFFqzkRCvA5jPSer8HnZEnNqaBru3YNpWkVbgfC6NJFz/Uj9FyPyOisLmdS5pwy
         YCRwaZTPKCKn3FKeG2HXKjy0E+2pfq1NwvWwgYvl31Y6yBF9N/xnBgQ40xI6e42sy4r7
         gztJew3LOYfUtekBOYxJkNpo54CRgmY2Tm1YIH4IBqAPpffGZm2mkggxbBZd6rivN2lp
         lQqg==
X-Gm-Message-State: AOAM531EuMkvwWiCDmQ4UGpPZtC6R9y/ID2B0lmiFpYPcLO40G5HtW7P
        A6nvU+WiIg8WqgjhOjnbn7E=
X-Google-Smtp-Source: ABdhPJxA4gmqBwbrufoJsOyk7+4vDgHdxH62gnb/euQNUtGZdnkJdcV4FIcESuWD9/Diketx0PnPvw==
X-Received: by 2002:a9d:74d4:0:b0:60b:18da:7882 with SMTP id a20-20020a9d74d4000000b0060b18da7882mr7804769otl.343.1653583308379;
        Thu, 26 May 2022 09:41:48 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id p7-20020a4aac07000000b0040ebba81054sm792016oon.46.2022.05.26.09.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 09:41:47 -0700 (PDT)
Date:   Thu, 26 May 2022 09:42:25 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     yury.norov@gmail.com, linux-kernel@vger.kernel.org
Subject: Patch for stable
Message-ID: <Yo+t8QAgVTi2E6B4@yury-laptop>
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

Can you please consider taking the patch "KVM: x86: hyper-v: fix type
of valid_bank_mask" into stable?

Commit ea8c66fe8d8f4f93df941e52120a3512d7bf5128 upstream.

Thanks,
Yury
