Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E023BE39
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 18:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgHDQf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 12:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbgHDQf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 12:35:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718F1C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 09:35:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c15so20687673edj.3
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 09:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ss0Zyqrv1ChIPF0Fq9a3cQo0Bld4187iQHtcWrW3Gmk=;
        b=ey6CK3QMjR02znsOn/WxdsbCwvT+PJOH5NcIcIeNnqfaHWM/slEx805kGwjORbK4jv
         Rh8o6BQdJ11L3iJDbL/9aObkLxUDPd2w4dW8U+CY4ZA+7qAW5WivcVu/rq0WfmALT+6R
         9cGNA8VeOPYXvvKDrHCztq9RbekIPNORibWwsvaLQDxY3ZJhE1bsbkidwhZhA+mK1Txg
         /FUcz97RbcKnj44J0f/RIp8PGZt44WzBK4ZdG+tWC6cj7ZOfX0QNO/FnMR4cErhsa2l4
         U0OvUk1DcvW/4MVcoaRpI9XxMwi5F+UNieSit7eA3f8MCOmsykmS0YKwCPw6micWemNG
         Kqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ss0Zyqrv1ChIPF0Fq9a3cQo0Bld4187iQHtcWrW3Gmk=;
        b=aL3ZjYSqv7GiBlWuPzbkXPQJGm6U0pGWiwLwXcf+M7PwWhjKERyOB3IwPikQS2D8OT
         WoCk68K7WoNggEEjbbsJRA/OpIINszfJwQzV9sKT9r5McbKeHML80MtHwebWi6Rp8nW8
         UdupwvjEtSa9aR1l/LePRQ9/i+iLJCwkkj9bGjLMUczjY4jfS8GqFZSPKxFA86sI/j5l
         t9qRVfDkYnLuIym2bx7KOoWmGcxxerz7r09KtfHsUx57ObxE/PhGtHEq5joQoCHvvMJ3
         W7CKaWrdne7IuhPVuX2U/qJjhzTBTfDam0TIEQeldQsYU40gcDGjdnEyu+inmtxYoZvf
         RYaA==
X-Gm-Message-State: AOAM530yM0hSC0+9XDaamI4j/2lo7flPEyYt3qbJECNJ9d9CZdw9vrb1
        YG5xJicfZmjMChYB0YX/zGisNgjYdAmIvnfvfWQ=
X-Google-Smtp-Source: ABdhPJxY8oqPS43cD8JXDIrjd7tb9T5Sa12ct7KamZUtn/v34T6M2T04gVNmPgumtLlr9n1XrKqoQynATMUG8UKOPxk=
X-Received: by 2002:a50:e846:: with SMTP id k6mr6887676edn.27.1596558953817;
 Tue, 04 Aug 2020 09:35:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:454f:0:0:0:0 with HTTP; Tue, 4 Aug 2020 09:35:53
 -0700 (PDT)
Reply-To: cdlm2000@mail.com
From:   Cedi <fougnossiafdal3@gmail.com>
Date:   Tue, 4 Aug 2020 16:35:53 +0000
Message-ID: <CALt1BNvE5Vya-JA3f2-vNx38NCMbpEuZH3ZntGfTu=uBw+8+Bg@mail.gmail.com>
Subject: =?UTF-8?B?0KHQvtC+0LHRidC10L3QuNC1INC+0YIg0KHQtdC00YDQuNC60LA=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0KPQstCw0LbQsNC10LzRi9C5LCDRjyDQt9Cw0LjQvdGC0LXRgNC10YHQvtCy0LDQu9GB0Y8g0LLQ
sNC80Lgg0L/QvtGB0LvQtSDQv9GA0L7RgdC80L7RgtGA0LAg0YHRgtGA0LDQvdC40YbRiyDQstCw
0YjQtdCz0L4NCtC/0YDQvtGE0LjQu9GPINC4INGC0YDQtdCx0YPRjiDQvdC10LzQtdC00LvQtdC9
0L3QviDQvdCw0L/QuNGB0LDRgtGMINCy0LDQvC4g0KMg0LzQtdC90Y8g0LXRgdGC0Ywg0LrQvtC1
LdGH0YLQviDQvtGH0LXQvdGMDQrQstCw0LbQvdC+0LUg0LTQu9GPINCy0LDRgS4g0J3QtSDQvNC+
0LPQu9C4INCx0Ysg0LLRiyDQv9C10YDQtdC30LLQvtC90LjRgtGMINC80L3QtSDQvdCwINC80L7Q
uSDQu9C40YfQvdGL0LkNCtC60L7QvdGC0LDQutGC0L3Ri9C5INCw0LTRgNC10YEg0Y3Qu9C10LrR
gtGA0L7QvdC90L7QuSDQv9C+0YfRgtGLIChjZGxtMjAwMEBtYWlsLmNvbSksINGH0YLQvtCx0Ysg
0LzRiyDQvNC+0LPQu9C4DQrQvtCx0YHRg9C00LjRgtGMINGN0YLQviDQsiDRh9Cw0YHRgtC90L7Q
vCDQv9C+0YDRj9C00LrQtS4g0KEg0YPQstCw0LbQtdC90LjQtdC8LCDQodC10LTRgNC40LoNCg==
