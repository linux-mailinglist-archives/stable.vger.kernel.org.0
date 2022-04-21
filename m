Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1A750A850
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387216AbiDUSrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 14:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386752AbiDUSrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 14:47:14 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA474BFEA
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 11:44:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g3so4743806pgg.3
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 11:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PBqtpkUhcWT7uuUuQ3gH/oVYXWOFA/M7nwE2TilqjEo=;
        b=ekSgX5SWOmmCDi6nB+C6FhujxZMUboWVzKaAGrJcOhUpXt+j8dYHZpyQ7JtjS9s+vy
         NKYIyNEZ07nEHxRfUQzInrw+uD5uZldVvxZu+SCwwBLzAwgRUUDk95w1PmLygxQjP+az
         BG078jnxZsG45xdcFtdi4/GhwK86h2ZgVee2OMAx7KcY4KIBVnOPTRzMyFjs7/Ute/6l
         PUsLudk46Bf0XQZYEK6UYmTpQiGZhkdkGteiY8wVOa5C9CwIXswQU+3H/mUl0nhr7oIf
         f+6K1IFuYwTgA2wy2hjxJ5kk+32Z8GZ5+TV9ORtEy7HmCnz0Ufs/E7va0XHRg7FPY+J5
         NJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PBqtpkUhcWT7uuUuQ3gH/oVYXWOFA/M7nwE2TilqjEo=;
        b=dVPXmRcXGP/fbhjW+V2cwkPVGk7wKUE+uIk8B6apnmCqbQ7eEUR9c+sbrl01o3Qnwi
         itFVdcOYtlS2y7irY8XuJkAdecEOQnSAkrAdZ/I86prtGV1Ec+pOQt9mzy+0LfI5U84X
         MUzThVSlro+KiYHBm8gskRn94h+6PdDYaOeck2TYryLX3R6lvVlqiVOIj8kx40zC5UVR
         ERPTPV4u4CsnX7huq+c0fwXQiiwg5+ZKJp/n/TB3ZY07Q+0VQ9rvETE0B1kUaGHzr9YK
         lypewYX25gwGieU0KjY2uYVt0LXXpvNZ3CQo4RgzODuHNA/CgEhVy2FVyGEsBD9Kxd63
         ubpg==
X-Gm-Message-State: AOAM532Th7zIqyuLzcVcX/iKmKeuPCAKMvbo+j+XR+5nd6c8wy1EoB0P
        CYBsaC84OnMRxmH4S6ZB289LOmvncZRb1zSz2yQ=
X-Google-Smtp-Source: ABdhPJyU90k4Zu98tHGEumo0tgw++SWw3yKbS0kLk6RxRIC0gYsCVTlh1zCF1zDJSfUnECmdcJ1xin/TUy8LYqBMnig=
X-Received: by 2002:a63:f46:0:b0:39d:945b:5f8d with SMTP id
 6-20020a630f46000000b0039d945b5f8dmr672314pgp.612.1650566663543; Thu, 21 Apr
 2022 11:44:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:7645:b0:5b:434:3b8 with HTTP; Thu, 21 Apr 2022
 11:44:22 -0700 (PDT)
Reply-To: wbuffett1930@vipmail.hu
From:   Warren Buffett <sa9558024@gmail.com>
Date:   Thu, 21 Apr 2022 19:44:22 +0100
Message-ID: <CANGbmbXR4HgYTDdseL=oz4WyVuTbRo_z5=_JUduuF4k0u82-3g@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Attention.

You have successfully been granted the cumulative sum of $4.8 Million
USD as a family donation from Warren Edward Buffett. We decided to
give this amount to randomly selected individuals worldwide to help
fight against poverty in your region.

Kindly get back to me at your earliest convenience so I know your
email is still valid: Thank you for accepting our family donation, we
are indeed grateful.

Regards,
Warren Edward Buffett
