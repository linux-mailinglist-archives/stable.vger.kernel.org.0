Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6A547787
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 22:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiFKUdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 16:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFKUdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 16:33:31 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26136112C
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 13:33:30 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g7so2812119eda.3
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 13:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=zbXZdx4tUetQKzs1xcJRM4xya4FHmSuRDE4vR6M7xQk=;
        b=flCGpc45gVP6yu+p5xZRFnv1ErWllDVbIir9+Mq7Jy69zwpiXOrH/U+YCA78ks46kF
         m++OMJ7L+T6UB0N9Xk3PW+4//bH1aaq6t7vX+rivPW7NqQBfZs1urPv0hRfOX8gCQ85Q
         zPPmMtLA6nEKXATacILZ1lTC3GuDE+a+f6H7oQlHnvx0s9+cUlem5Y0y/SxpcMFPcdbn
         ayziJFRvMG+887hx5nm0E073Uwn5ndAWgDZyL4zMXnPhFVBpt+y6XInZX3nwQyVtJjdm
         o6sqkbmxm1cXREmQ/IXS/qEDnphiK3JHABTtrg+vUbim7JiMPu3tjeAEXg5AesvNaC4v
         ibrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=zbXZdx4tUetQKzs1xcJRM4xya4FHmSuRDE4vR6M7xQk=;
        b=JBJ/dc2T6OYJ+m1Kr65fupei7i2iVaAxq6LwrCYASeq/ZUAV6YYTRuu5NItujkzk2x
         3M83lpG0IPtZ43nwQYeNKbFt9nNlMimjeDM7+620SiKOmVR65KyU7FTRdD/h5MAuqhpP
         a99vQBfLCUBQ+v7UVUMHQEsiyLpxNNYZiShQWB1oZ9boOpGmsJl2vMY0hpob57G/aiCv
         neIV2VeytUF98G+5kslMESmomdQkZcvpI2j12UWhmqmSwzHObOR02ZGvz0dBHKxgRjJH
         3kJdfJ2TNW1/E3B1owNBnxNL+vyZyhnCFrYPgg0QDiVqcS64f5D0WZz4UzofUMNdJdya
         Pj+Q==
X-Gm-Message-State: AOAM530kIfxA0t8fUJY8NvvdkiuCDO6RRWd4lw2icJTgPnSARymnyddi
        wd8wEnxtBZ/lHQARwdRUKxQMkXVgoszqupcKD1A=
X-Google-Smtp-Source: ABdhPJye4PceNV1qyDRFADvN4MDhFTDVlT9OOJH7HbTwkHti20JE5Hhh9tLaen/95x00S4tJDHHPHvEKnaf8Jh4/fvs=
X-Received: by 2002:aa7:c508:0:b0:42d:cc6b:df80 with SMTP id
 o8-20020aa7c508000000b0042dcc6bdf80mr57343758edq.393.1654979608733; Sat, 11
 Jun 2022 13:33:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3151:0:0:0:0:0 with HTTP; Sat, 11 Jun 2022 13:33:28
 -0700 (PDT)
Reply-To: bonchzarem@gmail.com
From:   Bonch Zarem <paolomark015@gmail.com>
Date:   Sat, 11 Jun 2022 20:33:28 +0000
Message-ID: <CAJaxUb+-cBnisabNDQ9PRO3nON9U1MqyZRsbVoFa9=vMYAwVaw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My name is Bonch Zarem ,can we work regarding to one of your family
member who died here in our country and left some huge amount of money
in one of our bank  and share this project together. If interested get
email back for more details Please reply to this email:-
bonchzarem@gmail.com
