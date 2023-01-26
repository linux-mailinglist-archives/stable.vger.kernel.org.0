Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A821667C968
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 12:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjAZLG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 06:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbjAZLG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 06:06:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96124B472
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 03:06:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g11so1485921eda.12
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 03:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHoGKdyUaGfzJudQLJ6mUwBwtlpCSU1wLKBE98os24A=;
        b=EI5sZINyP3hVXmcdde/qcYos5BIK7gc9tuz69B0F+SHt79+QXGNYeyQV4LItVFhMYP
         T/vezdBHn+4+qd8dlIF3sVyUvCxbGsYQbV5K7tfVKTkpOEdn0jM3L9XB00+SRqals68f
         UEm8OoAm2O2Ezq4RD5TVPc2FkczpIbaDSLREy/u2p7vqYYQ0fuv3l0Cicq6AxHO4Z9h8
         r6bYjxpFnjMyIYJPGijAUVDa35fVWBCi6JURxlov+sXZi+iZOI/yozxd4mrCXSyxT+0k
         /t4TQL1VROaFqBAwly5DWLxyBAYMXnvLmCoEQb01jMzS/lk5e35p9bomfywRh0Otns8e
         67yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHoGKdyUaGfzJudQLJ6mUwBwtlpCSU1wLKBE98os24A=;
        b=f5D6d+6whmNp4+KmkjKqGBTuiEhao+iGZdTp2zcryEjgR99rtA3ETvQfvkmWKs3yIM
         urPzZ3ktS9+4RDBqyLo9CyhS8BceYGWsRJjRGt/4kTDZdJBF51GkUJCk4ApWOW1sEcng
         P0Fe0mGUJR6WP6idiNxWkM77C4/WrdUMS8xrLG3Y0fsxw75shEUiCaOJ0Awo5bj1Ak5P
         WhcpcAYTzG5zA8D+cYfNhCB0YlabEg6blnwubuFbtgOmtV59pnx+/jZv3hpNcexAtpuj
         gTggx15ZXfIaCty69uGQKvQ4RnLXzu8xEo6uPScUyj1E9OjzpB6Cbphe76o0oVVdk+rv
         xK9A==
X-Gm-Message-State: AO0yUKV96Q4AwFcqfkUXMzHQdYwM2uslcneHoFDeqisY4nVocJ7ukMmK
        eXQcJmaEsuxpGfS/OJqXMOI8C2sOo8kTypM3bmk=
X-Google-Smtp-Source: AK7set8tkfDNit1reeuS57RN4KqQmQ1rNGTIKegQClfGS1vyTvHddyTpHNKj0xEU+wT4ahicUjZ+q25vMbBuPtSDVWc=
X-Received: by 2002:a05:6402:175c:b0:4a0:8f64:cddc with SMTP id
 v28-20020a056402175c00b004a08f64cddcmr1679216edx.58.1674731186033; Thu, 26
 Jan 2023 03:06:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a50:3a07:0:b0:1f2:5981:9f30 with HTTP; Thu, 26 Jan 2023
 03:06:25 -0800 (PST)
Reply-To: almondhongu@gmail.com
From:   HONGU ALMOND <missnatachaako@gmail.com>
Date:   Thu, 26 Jan 2023 03:06:25 -0800
Message-ID: <CAFxgcfO71SLBr=GS_t2UzhexecC0RHuZLrJdwfjq5ms2GbxxiQ@mail.gmail.com>
Subject: Your friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good morning,
Happy New Year my friend, how are you doing? My names are Hongu Almond
a humble citizen of United States of America I have a mandate in this
2023 to carry out a transaction and I choose you  profitable please
write me back for more details.
Your friend
Mr.Hongu Almond
