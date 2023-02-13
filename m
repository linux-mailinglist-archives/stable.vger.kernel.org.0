Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831766947F1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBMOYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjBMOY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:24:29 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E111A641
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:24:20 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s8so8194710pgg.11
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1IKJhZd2cFwm3AwDsdva9q0/F7bF3scCaYJXkjQZhk=;
        b=Jk6juhXFyXsVtntk5AJbto+fGBW+8R560LFWZhz9uNVyVWMSMZU+7FngYJAxaXFWdq
         5okA2EaUR6Fe2+U/QOn9i/TDaiNHhxIlx7Qxpa6K3hoPIBrB/hnm7ZgOvcZFJBjgIeZY
         eH4JcvHw/ip2hIMrFAZ2KIE7gB99VVKksa5JNg+Q1yH8bXsgRkES18mVocxrv+su62FX
         u2lBcMkKr+J0qPXOlZ02kPJgC9JQaMIqdjOeT05JLEbsH4onvMSCCvULCdOTllIJEus8
         OMXFjvQ32heDJnqTQ0tJ/ziFFMXNR28CUMavoYyRspmuS+8ktFr+eEmQ5VoNacqpVrSV
         HTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1IKJhZd2cFwm3AwDsdva9q0/F7bF3scCaYJXkjQZhk=;
        b=xGhI83LuuR0LQcSdLN1XdVQExCmtsB9B0/QeE6zKp+WZrtQzJz+D09r1zWcty4NCs+
         XDwsT3VFpGEQApUCPBRZkpU9iiPtdaR1if5YxfXZimd/5yilvpMbwx1NqwZwk0wjHJVC
         /mPoJPNCcOIe/7QmTKuEqvPzVP5mlENq3FI7rSyb1LSRYZCtLosbM9ohE7/aZ9mOyh6r
         g+WsPjVI7jDpZLosCZODealtC+KGelcmxtnqGMuDMu+ytcie/i13nKh5Y0NPVftSAUzK
         5AzennroAcmQ41Zb5VljGq6vhvgtqnWRAv/E4lZ+4razdEEEKFzesD84+YfoKLmG9rwh
         cHnQ==
X-Gm-Message-State: AO0yUKVkA8IxhwWBx0mHiI3sUbphOq2cVDDAaKMp1te6XtMYQuvpFGoa
        b+03gewkwmjBO/5rBdxFvXiegg+rmnUECZjNmToR1TYB13M=
X-Google-Smtp-Source: AK7set9rzdua9IFBbdPPLXbCXYKFrJPOnN3BY4XJDvv5YYj/scQWAPJ0+moBtm/Y75hqTjw27vEGQ6d8Beyr1CCgnjE=
X-Received: by 2002:a63:af59:0:b0:4fb:5429:1c36 with SMTP id
 s25-20020a63af59000000b004fb54291c36mr1294579pgo.91.1676298259595; Mon, 13
 Feb 2023 06:24:19 -0800 (PST)
MIME-Version: 1.0
Reply-To: mantheykayla29@gmail.com
Sender: awademathieu@gmail.com
Received: by 2002:a05:7300:bb8f:b0:98:5d4:47d9 with HTTP; Mon, 13 Feb 2023
 06:24:19 -0800 (PST)
From:   mantheykayla <mantheykayla29@gmail.com>
Date:   Mon, 13 Feb 2023 06:24:19 -0800
X-Google-Sender-Auth: jdoaeL6SOsDg34cZjboA2VgTQA4
Message-ID: <CANeh6uHhD03MTPXC+F1XqW537BPtiSPZGn9Eiva9YurEmH6q3w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo, heb je mijn berichten ontvangen? controleer en antwoord mij
