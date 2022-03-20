Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C11F4E1A84
	for <lists+stable@lfdr.de>; Sun, 20 Mar 2022 07:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbiCTGp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Mar 2022 02:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244938AbiCTGpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Mar 2022 02:45:54 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702812B25F
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 23:44:12 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id n35so5293718wms.5
        for <stable@vger.kernel.org>; Sat, 19 Mar 2022 23:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=nHz08v+KGykef/EY5wszhlvcWuKfz0UE0QFNYs1Ac5U=;
        b=f3uxqR/pumNQLSXTL6sX89EKYPdUhmCE26cSXJ5saDOfQq0nreznxxRLJGKVHLi8Lg
         mudHViz6cN/yJkHQa5/QX2/GjkIEnnlw/6Va3Y+uH+e9RpwFTlQ3S0ZAiaG3rZNZfnlC
         Y1JJ46n+aXGt8lpcjNnhooNMbrmzKpptpPzNIktQo3ik0SH1fWB1zZgZr4A5zUhFX31t
         diLZbsoxwR0nLpPFgX+FOT1+w190jtfck1jpTFNXnY2eGgfaRFtfGSSlg855CqfSXUHQ
         1bh8LkQKA9RANw7UjoIpM2arhotPkOtqCwcEs6EZ4ITSpG1yHXf17zGWgL+caGre0MvW
         gYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=nHz08v+KGykef/EY5wszhlvcWuKfz0UE0QFNYs1Ac5U=;
        b=k2XTvNJ1YyAnjgI3HUQx52GbcuzG0N8ilp1+JeyjYtNc/CQZ5TJBh8g7Iy3zSd0Rll
         KCe4wZ5y2wGwStNDCR8J0mtSog+6wdm8Sj2Y3sdkEfG0YjAZh/2M/mwbXBqn/SrmZRPK
         uueLIHI2gACWHBO4p1EytG7l5BTJ9ECqqLYYmXESK6MCJrvMZg1Can+4AP64aJIXMUXE
         RlsZdGn6810iUAM+hRWZBaPLW5PWjmx328MrbmrLcw9BIHd3ovhgVymRZauG/Zg6OaIC
         66LL4DdTE5P6QwhpaBpXFJtyZHl8xnKijieSyrKf3kkva+z6xWDENicRVY4afbKqSQNV
         xUkg==
X-Gm-Message-State: AOAM533vlNOEHdhqNb6c1htehQYlQpb9B8XmhAj5fyomw0cw0XtYapkz
        aIwnhok19Yv4J1HfZzN4n9A=
X-Google-Smtp-Source: ABdhPJz4H1iQAnXqMi/ZStuAqrjrQp/UP+QgBilbGcKey6ip5ciMWgI0GizQWU7OkmujqAXmir7gKA==
X-Received: by 2002:a7b:cd8f:0:b0:38c:6b66:e4bd with SMTP id y15-20020a7bcd8f000000b0038c6b66e4bdmr14822759wmj.12.1647758650683;
        Sat, 19 Mar 2022 23:44:10 -0700 (PDT)
Received: from [192.168.0.111] ([196.171.25.64])
        by smtp.gmail.com with ESMTPSA id m64-20020a1c2643000000b0038c85aade4csm6316305wmm.11.2022.03.19.23.44.05
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sat, 19 Mar 2022 23:44:10 -0700 (PDT)
Message-ID: <6236cd3a.1c69fb81.ed1a4.7e4b@mx.google.com>
From:   "Vanina C." <curtisvani00102@gmail.com>
X-Google-Original-From: Vanina C.
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Regards to you
To:     Recipients <Vanina@vger.kernel.org>
Date:   Sun, 20 Mar 2022 06:43:56 +0000
Reply-To: curtisvani9008@gmail.com
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings, I'm Vanina C. how are you my dear, Kindly respond to me, it's my=
 pleasure to meet you, hope we can establish a relationship from here.
