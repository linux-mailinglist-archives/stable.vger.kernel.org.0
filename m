Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF25E7383
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 07:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiIWFy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 01:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIWFy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 01:54:28 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FB311ED69
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 22:54:25 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s14so15753468ybe.7
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 22:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=xqV0SEJtZbR/dGKSwq8YnqP6PVCCHS5FOV4KkHOfuyU=;
        b=N+QlD9UgVGhh2CSjWgePefgvKOWOB3YqfQpWzmC8vHmaGgo4PpjkSVESpLqkvKarq1
         A3sVNMq8t60NG3QeFALqhGAdafri0/FnN52FFW4cmWyfnt03lt7g8LWhKJUG0zwtC3wx
         T8AAu8Uw0s+w3GLXSDau49GbwzZIXCXU8k7iaauhkhsu+PUDyXTC8XlA8pYltjsZZU8F
         3vzM6EyAPIItZgC0wtVqn93oF1O4D9aLjrDaCVunAGObIr2rDjx9w1QtAAvE92c97eK8
         6UlsRFfhDsZ1Va6sG+BHCB4MxwXfrvCTd+/71M/X2hNKWF/EoiL8XVFwveO3jGuWIB6K
         OuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xqV0SEJtZbR/dGKSwq8YnqP6PVCCHS5FOV4KkHOfuyU=;
        b=cfJ2NDF+vLl/SLK5SWu/no3bgNSvxyee8n+g86Cbbg327Hmvgw2myM3vQofKpE/vG1
         KGmC65wv4LG3OlCCykYVx3B3wqTmjMlzCXv93ty1khABsec+zBrW9/q7fRFwO/UeqJuv
         w1JAUp63b6FdZD2YfPbFImUw0FAj6hQZCxJOsJSCejaVSgZW0pBBDZWWcblzMywzOe6d
         w+uRZ1HzmWWzPutL1bH80n/OYk/3gSgW3LfxkzcOwx7+hePng90PXj1LV0mOesPx6hbI
         ZiL+Qnc24avMG71PlnZvMdbXdfmn6YuoBqvhdkz+SHaEDFRbh4yJebyzNPCib3zxEclQ
         QacQ==
X-Gm-Message-State: ACrzQf0HhXjR0NFL8ACWmoMeII1uCVW+psVzJYUPDAC3Ij6ArYYg9D7L
        /HZhNTJB759vnPJxEyS39RVsPMkQ0F1Kk8MDlmorMBcS
X-Google-Smtp-Source: AMsMyM4CGBtML9KiOkEBdbsQbhskAZvxgfSWDfBKMGYTz7dwS1kP3nbXJHlLP62OeREySlGDqbFBxEgUN7PUrzbTLcs=
X-Received: by 2002:a25:8407:0:b0:6ae:da9a:4031 with SMTP id
 u7-20020a258407000000b006aeda9a4031mr8083540ybk.238.1663912464911; Thu, 22
 Sep 2022 22:54:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: andreamoussou252@gmail.com
Received: by 2002:a05:7010:4ad1:b0:305:51c9:23a1 with HTTP; Thu, 22 Sep 2022
 22:54:24 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Thu, 22 Sep 2022 22:54:24 -0700
X-Google-Sender-Auth: SzpApo70e2Ab8L-nYivY5Ua_ihY
Message-ID: <CAH-QM3G1SHKfrBL1+3UC=65znZVHMhs6Osd0pGYiAjCkqCFLDA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, did you get my two previous e -Mail? please let me know
