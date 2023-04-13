Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A5F6E184E
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDMXdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 19:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDMXdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 19:33:15 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AAA10C1
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 16:33:11 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c10so2671857iob.9
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 16:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681428790; x=1684020790;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZPaqozltHBRIF9flmTSHSt6Bd+6kI7/u/0X1owpSVo=;
        b=E5GN4nEwsi207S9IdmHk8MFvzkKb6yyydZ4H/5iD5PKQzvqTsGCmvvS50Oz/+Wx71k
         2OzbsYHNxRXAuq0cjy+fqBXzLodW54XZxRL9Sr1xh+u2s8QxOskFPkn4UJivpk2rAtPW
         SM+8DCsnZytu/c3hraa+qKv9P+DbU/7k76mJhCclvKIfrgMmsB285twzHy2mn3SM6QYg
         N9dqDA7AESF4fVqHBHv56wLYy+re37oEn3pSvZr8H/ra74NrKEomSxPCxNYUjdQWqyCo
         dn4g8RklF1lRxsmOcsRapNg7AGZARRwU1BvB6NcOgwTG4TAgEY5pFHE/g+WtU3ytpsD6
         qpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681428790; x=1684020790;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rZPaqozltHBRIF9flmTSHSt6Bd+6kI7/u/0X1owpSVo=;
        b=d5flYZ03M0I7mt16reSbOA6G/oRpAjQLJ1B7EIRemz9Wq9S7t4pattWs8BtIWvMKwJ
         lR4WEXtbaH8VY760vSdSetLLWIdvVN5u3txEslcOb4vUStpQ6WJHEgqCMdkcWnbfTfu/
         OEcppoankqO0H04WRtLryPiLTudi4glM0LW7IKrwTOr3wAre2wm4qNV1kd8QjyWv2XeJ
         xhRrz8dWmAqmFhOMm2NaodMVmpZXsbRwUoFb2kGF6n4UhmEsLV8JtL7yvdvvMgJ9JLyv
         BeFS8g/tXqvywq/BzO0+dDQ0gL2QP7iBB4/xgBIxG18wip12QH+Mu4e3/RMkeIUynhiH
         unZg==
X-Gm-Message-State: AAQBX9f9XYqeoYlONKggrnGJ0dCHqY5ua6F4UJquwD/K9PrNcFdBzRSt
        2sFZNOpJRWRQuaYwZfENbUU0+ty/HGbnb1QaPoDjLn9lPHM=
X-Google-Smtp-Source: AKy350ZUQbYVWHY40d3KvlALujZUUhuz/hmRKOhF4v6nZcqYcJlhINwLkeQMzIH495KYixRro98PYo0Ay7y+yCqhZ+Y=
X-Received: by 2002:a6b:d81a:0:b0:744:d7fc:7a4f with SMTP id
 y26-20020a6bd81a000000b00744d7fc7a4fmr1638702iob.1.1681428790437; Thu, 13 Apr
 2023 16:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230409164229.29777-1-ping.cheng@wacom.com> <168139664776.832846.9285685297324282380.b4-ty@redhat.com>
In-Reply-To: <168139664776.832846.9285685297324282380.b4-ty@redhat.com>
From:   Ping Cheng <pinglinux@gmail.com>
Date:   Thu, 13 Apr 2023 16:30:33 -0700
Message-ID: <CAF8JNhKZvecDxYf3SMf7p4TtQmRC0P6bVagPc=K=0r7h6wtc7Q@mail.gmail.com>
Subject: Re: [PATCH] HID: wacom: Set a default resolution for older tablets
To:     "stable # v4 . 10" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 7:37=E2=80=AFAM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Sun, 09 Apr 2023 09:42:29 -0700, Ping Cheng wrote:
> > Some older tablets may not report physical maximum for X/Y
> > coordinates. Set a default to prevent undefined resolution.
> >
> >
>
> Applied to hid/hid.git (for-6.4/wacom), thanks!
>
> [1/1] HID: wacom: Set a default resolution for older tablets
>       https://git.kernel.org/hid/hid/c/08a46b4190d3

This patch can be backported to kernels as early as 3.18. It fixes a
firmware HID descriptor issue.

Thank you,
Ping
