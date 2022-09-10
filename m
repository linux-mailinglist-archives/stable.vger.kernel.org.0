Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE955B4885
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 21:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIJTzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 15:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIJTzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 15:55:50 -0400
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D352251B
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 12:55:49 -0700 (PDT)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-1278624b7c4so12791728fac.5
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 12:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=675CvuSp++zNLeIUZybBsP51nvc83dY+2bSGb3FYErQ=;
        b=B1GMwlatSiHCQeNwJwEiq4jRMW26X2UP2Zsyn7EvdGyohXs5P6AYapqAgVPuA8koaR
         mHoAkWqBZIS22oJ6aKWUgXiwbrURC1butTUxMeoLvS8A8PHXWK3W6WfUrr7CzbjqiFDh
         Uo1c/r6FbXhtlkmVeWNo6rKKMRuFIpcAD7f2p5sx5S71eNNYPc2+iTdiDOwuNrAaiPpL
         O3W1GvojzT30CVotZJuO8IcUYVB1FVJJ0a+MIiXfakyyNBDPrNoYbti0TPWfVQz0X8FF
         n1q7xn7wI+P4EUnVISS1ZVGuSrNtWS6Al6+wqmSMvz6sROAKgD7li526ztSE7pcgEn5O
         JZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=675CvuSp++zNLeIUZybBsP51nvc83dY+2bSGb3FYErQ=;
        b=tCEhCM+ftKbHYrRWKcAP3Is9nUAR8jmFKjlieIqFOdZ4svT5HcChGy3SpGxyk9euDg
         NpCsDUsQWMwPtFL6gtKTQwAQFmLEktyT6PBoQyFdWLJ9HHPHFCWnQqFsrZJ8BovyArKc
         gN96o4uwk62n57COfM93ATeymg5zSbYfGWQ0o7hXHQA7f8FdGBD0s8VeUbw+JVBlqTGi
         +dFWGWO12bvyCSoX0Lv1m/qcGjHkeF8N+RSURq4QJL6muWh7/2f6H4rSZXp8SNQuVXAv
         BGgTZfC/tzOP5k+zw1LyW0fBV3PpOeDqAP2XLxleGxAok6oUFfw75glpWWeU+Qm5+kIl
         aHGw==
X-Gm-Message-State: ACgBeo01HHG6pJI8liDxXlyxu7DL94axzsaCaKsBzfrx5OzR2pYbXPHH
        xn+eRkbUHzmR+jzkb1G3GV4R64u7JxdZAdk59ow=
X-Google-Smtp-Source: AA6agR7T+9Uelq4X8bUChUUBQYETEXfkotgpV1U8UTuJtvQHgiMGd3KVpn7GXzKSBSCMbGTZWsUFwutgJaaekNTpTr8=
X-Received: by 2002:a05:6808:1447:b0:344:f11a:4415 with SMTP id
 x7-20020a056808144700b00344f11a4415mr6150496oiv.51.1662839748660; Sat, 10 Sep
 2022 12:55:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6841:132a:b0:e78:416a:a164 with HTTP; Sat, 10 Sep 2022
 12:55:48 -0700 (PDT)
Reply-To: wen305147@gmail.com
From:   Tony Wen <infotonyw@gmail.com>
Date:   Sun, 11 Sep 2022 03:55:48 +0800
Message-ID: <CAGsB4p-VS9K=Kg3LH7+-kvWfORGBQ4VhGu26qXHv9fg-+-ZmsA@mail.gmail.com>
Subject: work
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can you work with me?
