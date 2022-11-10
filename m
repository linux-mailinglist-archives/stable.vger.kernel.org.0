Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200C5623B02
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 05:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKJEmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 23:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKJEmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 23:42:18 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C0C252A2;
        Wed,  9 Nov 2022 20:42:17 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d10so804462pfh.6;
        Wed, 09 Nov 2022 20:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dKXQkpjoEzDW/xgiAGdVV029gcUFPc8S4Xow5laIKTQ=;
        b=ornR+jXcUXkjvPZMnh3c7glnujs28i38m77CsYyPK0OhXyYy60a8vpGsa5h/XbUP/S
         +8ktWq+01S/FCYKFtFHiHjae+IrhXVxy2UN/DL9j7PJfKHvWVRl0WJwv+AXHhLgoRnjY
         Rit4CTSSPaG9hR4JWLlzFYT29QVkcznxnz63MpIv74xmTVx4Af4nEPS7K5CP071GPVgc
         39rpo4WkKfqS/yYnl2mGE6vdACbi/A5VzMTGYugyo5FzQyMn+aW36i1RmqtUmZUcZF5j
         2CWjH5DqpNuhv15cH6f6jHQftDveQ/XMftWCyDc1OiddawAQ1hhKvadGBc1c1My7leYS
         FLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKXQkpjoEzDW/xgiAGdVV029gcUFPc8S4Xow5laIKTQ=;
        b=D0buKmZo4H670W02xfrHKdOhLzaZwDf8bFLlJzbk9X6ap0oXTEkOlIfYnt/+5LP1Ce
         0j0/nx2sMiasSjaro8aHtqkqt83sY232INci1muVZxMn4CRfAY3DyXqg0ThV5AewQpgB
         C+OTfR2AYm3UOTraYsfEyJA1FoIOExNV9nsHterCHVV5MibgzjNsqIj9+W2M8ZUNoATB
         TEfIx2h3V/NONMJm9kUGiSR387JG2nf7RcMwcNF70ENTmO0ftYoiO+DJk2GMu7T8Onxe
         Qk0BsH60F/1A3Rm1xPwJiLbBDPXBRhGMCLVcXciznC1EFzPH81wWi08eEhITvCZSrUpu
         Scyw==
X-Gm-Message-State: ACrzQf1lVyZwGQXvOJg3Ijl2ajlQnX2iKO5vugha9ANkbA4ychi8Uuy+
        Bz6i0bZAI5xL4AMYmqnXpW3aIUaxtfpXPbvgXNg=
X-Google-Smtp-Source: AMsMyM7l7z0Sb/i01mA8jb6PgriA8pzHxJFs25YVpnWQqZ5Egk/Xi03zdg6wLGLowQeisIGgf4fSWXwCSyktEmPvRkY=
X-Received: by 2002:a63:1a46:0:b0:46f:d4b8:409f with SMTP id
 a6-20020a631a46000000b0046fd4b8409fmr1783480pgm.475.1668055337242; Wed, 09
 Nov 2022 20:42:17 -0800 (PST)
MIME-Version: 1.0
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Thu, 10 Nov 2022 05:42:05 +0100
Message-ID: <CADo9pHhbghCZzWsZTBPH5SDtBd+idrBaGeHa1tnvjnHzQTRvBw@mail.gmail.com>
Subject: Greg KH on FLOSS Weekly this week
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luna Jernberg <droidbittin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://www.youtube.com/watch?v=jlqKdW-B4Ug

*watching now*
