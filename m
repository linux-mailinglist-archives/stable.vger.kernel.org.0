Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16C57C140
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 01:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiGTX5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 19:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiGTX5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 19:57:12 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7579C19C12
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 16:57:11 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id x10so22465832ljj.11
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 16:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=aL8HieNDyTeA84M85X3HbVtOkXKblZr7b/Cbonpr8KBzZUV9qXzQCdcGoMUy76GxeH
         QfOSZaZkVxkXZL2GyuYevr8hYNZj7uZCsmRkQJAjmLfkVouT3Vg9LPoR89UQH7mpmzj9
         6CrJC4zCK7XKZg8Mlt37FEuuvaP1oOS/Iu2/SSoe1eHhdUKudl3vfi1QfKEw+ercI38w
         etGZx4IuBC3U0tMeuyUP4bKrmRIgfkcHmqECLERm3swAcU3ZBsJTBJ1WSAix2ar+xUcy
         ZLQLTmnweCZhZbGk0tD4ExsiGdAKnHfSz7guqtbm2MHKvYOVvRpov5aHE8laOG2VgTAu
         SHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=PT2aiKtHaVjfu9SNFGrCHCWDF2LFgeGmfbD3TZpzol6kDBiRqGYgYfrUPVquNYuavx
         w8lFQGAS0W/LQOCv0X5ZBmnH5C7SBrMYGZTZGlwwYlsJXfSuGZq+bqkDw9cTQVXX38wh
         EpsR1tAMjrV2LL9xaBd9KH+U7paBFzYwIldiLwl+JQk0xlTUoqQl4WNAgu+DS8CNRPN+
         BKCi4AEcCR3M75EpebO8JlrDAc5FOWHB8Ks2zDydZOcen8G0hVav7xRD7McBSF3Myf2D
         wqaSLMcwu/aadppbAN4/Ih1qENbboVW8mL40umKuNWda72CGDv+OZesJ2++ofkmCjKhm
         DeHA==
X-Gm-Message-State: AJIora9ET/L9uUcg/mUVQId9k3EeaRFqi7M/YNRVIySWcJ2CTys+IJvJ
        nnnCQQj/bblWyaxo5ERHxmEZ5dz1tZn3ilYF+oV/jCCD4B8=
X-Google-Smtp-Source: AGRyM1twiwNWDEVwAbFoMJKfeqWpd9MRSuRzFxr5O2TzL7ZXYp/O24z/M0keUtu3BTmyN5zBvLqxkUrHnXEHBR2f1Ok=
X-Received: by 2002:a05:6512:1109:b0:489:e7b4:7cc with SMTP id
 l9-20020a056512110900b00489e7b407ccmr21007650lfg.617.1658361419390; Wed, 20
 Jul 2022 16:56:59 -0700 (PDT)
MIME-Version: 1.0
Sender: mariametraire@gmail.com
Received: by 2002:aa6:da56:0:b0:1f9:e433:303f with HTTP; Wed, 20 Jul 2022
 16:56:58 -0700 (PDT)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Thu, 21 Jul 2022 00:56:58 +0100
X-Google-Sender-Auth: ksqNe6pNS7oZs0c6LLbwkXX85nc
Message-ID: <CAL3rPFvWahiJ=2iejp+JC1WZE7RpemAqTOxacXu-vPMu1WZjOA@mail.gmail.com>
Subject: My name is Dr Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
