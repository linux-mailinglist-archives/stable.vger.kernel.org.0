Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2626C2CA1
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCUIil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 04:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCUIig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:38:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F297EB4E;
        Tue, 21 Mar 2023 01:38:04 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o11so15283561ple.1;
        Tue, 21 Mar 2023 01:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679387883;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IhiEXEyTGcdUxfBPxrZJ+Sx7w1Ag4vhfNh72LHa0hJ4=;
        b=nnJclekWZoU2ry/PfmgIn6NKdYwHjH9BsN+FP3Macpi5PJmcbJq1Nyle5QmkuPKeeb
         xIgGWuOV7PyDc9AhZqBlGsj0r0EfaVm5iL139H6OI0HnDxNnz+PGek+CkKycUEQQipJW
         M4gIMwMBSY4F+oDaQwi1Jlj+/XKHSN42cM0g1NbY91fdQgSwq64nKM7wXB844KCKJ2MI
         DjhihqASsFsYuXs7YK30n6pDbbK2G6sv3yg6EQ+Vp7ng8jnsrZVoEA+7KlS/zhtg0U/p
         UMLMcrTtH9BELkjuRo4/32D9C6LgPf9Kct9YuPpG9WwB24yKh42l2jQdKr7zTBhn81WW
         l5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387883;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IhiEXEyTGcdUxfBPxrZJ+Sx7w1Ag4vhfNh72LHa0hJ4=;
        b=TwyvV2MEMToMayrgTj3Ex8DB9thug+/mzJQELV+xiXmkdQG75+UFYiDbFVPBF1HwZL
         cQtzj0BUVK9Y3vE9XCUc6OcYzvVh6ClK+75g/7u7+n9AXNBOBqBRTlaH7xrc6SLdJvcS
         2JOm0HUYePpWrdTUu8PhhL8cz8Q3so9WhON2BzvxEqQD4WiMQ13Hyj58gqa5EYk7rR/B
         VfBaGRX3f4Xmm5xp9pCX6DNuXwVrIeXlRy+m6Fn4HkZLaUv4fJzFo38Dgddj8nLNDbHa
         wHIwcAL8r7yJZBUK9InuwhlkdgRre5Nxo27pXlK9OK9wXtUWj36eAjMgXmODdZZopNvJ
         +zOA==
X-Gm-Message-State: AO0yUKWBxDHPAVbGjyC5BPxRuu6K/+lm5tLdh0xOeEYmA/WUq/VByGb6
        oEXAxy7o4aKjrJzsviE9QbYtAjZhc5ukvA==
X-Google-Smtp-Source: AK7set+uwdKluX7gOqZ7nvo57v5vID/nGwhHRGi7uuQhSk7/gG0Nv/P0WQOUwwjqoH5PelR4EZkvqw==
X-Received: by 2002:a17:902:fb4e:b0:1a1:dd05:39fe with SMTP id lf14-20020a170902fb4e00b001a1dd0539femr1304426plb.4.1679387883571;
        Tue, 21 Mar 2023 01:38:03 -0700 (PDT)
Received: from smtpclient.apple (g1-27-253-251-242.bmobile.ne.jp. [27.253.251.242])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709028a8800b001a1d553de0fsm3013978plo.271.2023.03.21.01.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:38:03 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   "D. Jeff Dionne" <djeffdionne@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
Date:   Tue, 21 Mar 2023 17:38:01 +0900
Message-Id: <A7A78CA6-F9F2-4AFB-8756-0965E33101C8@gmail.com>
References: <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Mailer: iPhone Mail (19H12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mar 21, 2023, at 17:12, John Paul Adrian Glaubitz <glaubitz@physik.fu-ber=
lin.de> wrote:

> Also, the Sega Saturn had two SH-2 CPUs

New hardware that runs linux is generally/all J2 SMP (dual core sh2 class).

J.=
