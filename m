Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3523BE58
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHDQq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 12:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHDQq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 12:46:56 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CD3C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 09:46:55 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l4so43119845ejd.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ss0Zyqrv1ChIPF0Fq9a3cQo0Bld4187iQHtcWrW3Gmk=;
        b=WrJ0RTWRni7Z39bcJiHocE7pcJu5BR22U0PditPWeMToj55SxmUhOUZ7SO1/P2UGg5
         IfAtbU+Rhf0J0TR7KdUM3oM8P6MaSErDD9f+rZ5z037Rg1sVo2ZzwZnT9wDEUKgGGhTW
         T20H961yK/ow4EJetUPL5nczQppkhG6yI9HifGx9mZL7Zeu2UansNjJqyRXHcpzrkGgi
         6NHWU4SLolwz7q4nQThPBxbfuBACe/DViWIgvyMcoNx/qivy5EQ7De4Xa46cvJT3Z3Yc
         rEbgwGMi2bj2+hupazmRWHet5zZohQ8eLTGAVtppkYhNzC0bMwE40T7Kps7auO0Pe5sr
         q6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ss0Zyqrv1ChIPF0Fq9a3cQo0Bld4187iQHtcWrW3Gmk=;
        b=VGb5ujvagG8aas2ZDo+1x24ti1SQEQTYQ/ueOOmIjUz4RKjbcmcq3UqRRyNnNggMHt
         bvhVZ/cegJlWSoOaLi5BaMX7SPyJi0sSWHYH+VT3sDStTmqBSZjhwlO/rl6OtCGN5+Wh
         GDij3SRxMGjGNWiNKiiSImahOOp0vSoMR2hVLQAHN/WPRKIQ4M0uwrRGdXitrskEQheg
         aglDbHeQuLrDi6vid99ds3IRQ7+G76z0q1ckkXmsG+lNnh3o5XBqjzJwENaEUv5gYI2/
         ufEll0RzGVGrYjVAdsIvDcy6ZWOSzjOcw0OXUHXO5L1IIFCCmilYN3ZkM9HDShFW6Uie
         wgjQ==
X-Gm-Message-State: AOAM532uhSYG9oVgesCI1BR3V6z1D0K0mRLQHyuvv21n/5d+By1/8+pK
        UpXHHtuJbyX/t0UVbb7n09BJ3r3Jf5HITNHhDNA=
X-Google-Smtp-Source: ABdhPJwwn5mQJuNdxicqHFhCcDLFMtIGUB+P+FTU1ypBijFw2zvXklx4jo9cwXM+xlnn5SHGhim3NLOT26CqwjP8hiY=
X-Received: by 2002:a17:906:7492:: with SMTP id e18mr21977394ejl.375.1596559614762;
 Tue, 04 Aug 2020 09:46:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:454f:0:0:0:0 with HTTP; Tue, 4 Aug 2020 09:46:54
 -0700 (PDT)
Reply-To: cdlm2000@mail.com
From:   Cedi <fougnossiafdal3@gmail.com>
Date:   Tue, 4 Aug 2020 16:46:54 +0000
Message-ID: <CALt1BNvtKvtg8osN9bB=OxvCBzEw5QOC6o6QghyxXp_3QbxiqA@mail.gmail.com>
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
