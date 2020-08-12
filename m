Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C572824291F
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 14:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHLMKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 08:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgHLMKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 08:10:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F38C06174A
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 05:10:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w17so1325505edt.8
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 05:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=19Imon+rxw4PYhfVjIkUXAZNJ+5MlIFrDRqnAYWCNGg=;
        b=rd3th9ecpSu1Znmav5CtbctWqO/kQMtzMFiWDBxKVxZ+K5dwzDUWuP379ZvfZd62FY
         2vH6jjDTJi0gMijifBu2DkYYJVuYEGVGad3GE3yDbglw5+iVSaCEudd0i1NHE+Aczo28
         qR6NfEq1ANFThxVtuwbLU11bUsHnpRBmh6r3iFRGIkSMkkZ0PLW5zWVQYCZWRoSJ4tvF
         QzO1Zo67/SE39zNx1tzvSxgki/XaxiQCQfrtDqmNkLzRDy2qxhgjURBxu94zDnPhR+1t
         xvzT1bYvjjBfmefT9wC5oZFWrgaefgS7Tp2M6MMx3GdWiq7M0LdpqEdwajB9nOHzWPID
         rs5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=19Imon+rxw4PYhfVjIkUXAZNJ+5MlIFrDRqnAYWCNGg=;
        b=JNZ03jBU+v4FiTvwDJ/bR5G+kP72+Yu7EtbTdJV3MwKeYmU+alXUbI4G5l9DwpWuww
         J1IQYYdmuSssTJgASDFUwQxOjwnCI3YDl64FvqUppM0laWY8ZsOWfhVYxHrq3u7QKp3U
         7WanVzsQ7N8cky0a6+vz0KCtVuBRkQHsf+VF7/kDMub/UZrQyB1bfn1mNxuVjXs+tYq1
         AvL+3g58zGILERq7iSM2YyZMKfXVffsbfCRUb/QucoazXVJrRnWvgOinQ5AHsfefTtxx
         j7QW4DPOv2mca+sC4sPIPngmeMzPmJtuciArFRoZVeZjEnPU5GoKZwILsrBcxfHMcc7e
         GaKg==
X-Gm-Message-State: AOAM530FbWvZ7gEkPIU7ojU9AMMPOecyEQKfkzYerxEZtgLkjcTrmP33
        pWF8fz0R1yWxVjUGzudlRsrVM9fNj2UzoW2emdsBqiYvNn0=
X-Google-Smtp-Source: ABdhPJx5R1oyCGfznDmaRvzKsNkTGrQ2G4sjWVwXpOrqoYH3MHP8VqcTbiDfMF7Jd8ZsqonzbX1RpRDHHbaADs/c8iU=
X-Received: by 2002:a05:6402:1ad1:: with SMTP id ba17mr1186760edb.119.1597234211330;
 Wed, 12 Aug 2020 05:10:11 -0700 (PDT)
MIME-Version: 1.0
From:   Plamen Lyutov <plamen.lyutov@gmail.com>
Date:   Wed, 12 Aug 2020 15:10:01 +0300
Message-ID: <CAOLo7rqADzuZ6nXwhDNO4e0-CBoPa3=JVQxoMcDTZtOOOR2Wfw@mail.gmail.com>
Subject: Nvme patch
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Is it possible 5bedd3afee8eb01ccd256f0cd2cc0fa6f841417a to be
backported to 5.4.xx to fix c64141c68f725068440fbc13eb63dbb283e99168
as it was backported to 5.7 as
02963f5752032ab987fae7b450d5e1e357e7425b to fix
e2cb0c5635ecf7d8f2bde9971edbe00a0b8b8536
