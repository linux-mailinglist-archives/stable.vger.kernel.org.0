Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB3648F65
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 16:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiLJPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 10:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLJPNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 10:13:47 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AD31AA32
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 07:13:46 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id l8so7895030ljh.13
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 07:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crFeEpjK0A4F3PHBESaPRe/9DY0Bz/sBDWX07yAOomM=;
        b=gPN+hpOo00g1FWcgz/V/yo/HsHmx2cEzEtcFXN+j8G+kmWbvcMl6vMI9MJhFW7vTTU
         CfEfiYBc1HbZT+mJqisVgSIJ57NVnyVjx1TCwEBbZ/FDiQKcLcoV4ckzpRmEajWKuRzl
         Q2owa6TkeBiySJEb3pYZipsGOjgZPz5YteJp0ZM/WmFfTMRucv+IbEwPJ6SUe5rgF6R3
         x1/O0NpoiKr0sHIHF6cZD26adaQsXxWYhGZy1eHEekKhqYZ8wKkN/kpxhYTp4axJ6RwD
         S6IcjgfYtOnpxbjxFbX+aGugeKOKc3o82spQEujYizjpJmhLwhxbSefOsJP0GmyiiPT2
         RhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crFeEpjK0A4F3PHBESaPRe/9DY0Bz/sBDWX07yAOomM=;
        b=mrq83k89Atu8U/wqh3RfZgjiCvqUC/YsXsVsPS/VAG7lsPxDiI+PcD/Ms2ytwol29U
         XTxD6cOIdM9nc3nqhfOVgBYhBHYSizUZz00+9hn+VXkug2SGv0WuAtRYFPYwPbgj3du0
         UUnbriU8llG8+oUGVkJiG61teFNAuDszQxJrqSXevbM6rX9Dr8dO3m95na1lcZDMJy+G
         N14RuhqCboZ7FAMNZvW13B6KG8e+WXB3wuRXow9wTuciTfAyz0f47vUnJda1k/yEL1Vo
         XHYhINykRqpYVyTfvWT6vpvau9gC6li5irUftx9J0rXUFCDD7l2z5fUiZzbsECXoqHj6
         W2qQ==
X-Gm-Message-State: ANoB5pmrDtn3OwZ77rl5u4S1uMDJbMCtauxIU4IhaGmPGHNEbedRRRpc
        N45NwGuDifYupcu0flue/1qhrEcZxJx41BbflZI=
X-Google-Smtp-Source: AA0mqf63RU/SeyeFCJ52g9T86qsqlIzTK7YvxtBprR6RqEHYDxllmtQHXhoSBV5KQQ/sMpITl3elMvDRP9mWAfs7aSQ=
X-Received: by 2002:a2e:9b91:0:b0:279:c810:58d9 with SMTP id
 z17-20020a2e9b91000000b00279c81058d9mr11364873lji.355.1670685225146; Sat, 10
 Dec 2022 07:13:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:1209:0:b0:200:5b69:6899 with HTTP; Sat, 10 Dec 2022
 07:13:44 -0800 (PST)
Reply-To: mdm223664@gmail.com
From:   Marcel Roland <marcelroland3355@gmail.com>
Date:   Sat, 10 Dec 2022 07:13:44 -0800
Message-ID: <CAOVoHMurUAM1ENffqA26na8EHgT0QnrUq5NZfo+uMrSsGpRNMA@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Dr. Marcel Roland
