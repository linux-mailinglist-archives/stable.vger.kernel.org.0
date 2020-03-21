Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67D318E0E8
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 12:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCUL6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 07:58:46 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:32962 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUL6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 07:58:46 -0400
Received: by mail-oi1-f193.google.com with SMTP id r7so9568370oij.0
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 04:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HXE6tstiCEJgLEvZqX/al+c2Uj3U9XPUohG/1iBPeWI=;
        b=dhub15dFBgk35HV1hPVK19mskg4Aunz0JYhChlSKrivQqmtFI7xgcpDt7CKqvIgLDw
         lPzfUUUoVyTFkNDzbIJk/dQgnVEGBvARfSXomvNoyXiMd8MNs9zDxB0DWR66yb1YfA5o
         YGapuZxdaeEKB0D2VPHzZOdL4dUERZuUJ0bxFVjTIirUeQNPs6CxnM63+JnyPsmxOpYJ
         zQ4XruWziDfaLpEiTWg2YRQLOqpWJsRXU6pXqmD3Fky1CYYVe38ETqMmMcSu1L5gwiyx
         wVvemvmSR0EhxZhOgbljcJcjzNOnEXyEXuUpBlDsKHProAeRA29/ls1yaZkTnt8dohtd
         B+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=HXE6tstiCEJgLEvZqX/al+c2Uj3U9XPUohG/1iBPeWI=;
        b=gNiAzSxbIdFQ11fZzfg5fDUoCa2aD4MD0QsTitWz4/JR7IEg/casLPgIhlA71uTPBZ
         ZLIYQdaQ2yR+QFTu7blg0kyBf6AHOCpwA+OHnCeX7Wurs0kTIJcC8d7hTEskmyekEKg/
         cmjvQwJ9AHOftPM2bWmoSaSppWXU+TFdl5LOueWBEjumr1d7ZLaNC3a17Cm2k6+vpKJa
         XmutZ96k0KU+wu02nqSPZwygfo4E734f2nHSzvFAat5HsYG6tQ6VJlFLQKPoDkvI/Gs2
         Hw1gSF8oLKpLOKrVKKwJaAyp3Y2Jwv/y3rpTsNhkYd+9Ib1Eg3FCcFTZl4a4gBUIRl/1
         25vw==
X-Gm-Message-State: ANhLgQ3N1+Pacn2yse+yCQPReyjQBgmHupT2YmrDLE2EyI+jTnFc5SNX
        G+PRNckkisM3+f/fdep+7JW18poWvaJmhi4KX1Q=
X-Google-Smtp-Source: ADFU+vv4+3xTHdSgfnhlrK6/FtkAWfDLWE0j9sQS2M2tJwSZobLknIWg9Me133TZdasmzCbzoLOZvOMCG3RFz4eiScU=
X-Received: by 2002:aca:4991:: with SMTP id w139mr10489596oia.145.1584791925691;
 Sat, 21 Mar 2020 04:58:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:b646:0:0:0:0:0 with HTTP; Sat, 21 Mar 2020 04:58:45
 -0700 (PDT)
Reply-To: begabriel6543@hotmail.com
From:   Gabriel Bertrand <officeoffice806@gmail.com>
Date:   Sat, 21 Mar 2020 04:58:45 -0700
Message-ID: <CAAyL4F-yJjjMUQmCzkW+6GL=n8zQbct=VsKS7VFAVW6ZBe173A@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQoNCuS9oOWlve+8jA0KDQrmiJHluIzmnJvkvaDlgZrnmoTlpb3jgIIg5b6I5oqx5q2J5Lul
6L+Z56eN5pa55byP5LiO5oKo6IGU57O744CCIOaIkeWPq0dhYnJpZWwgQmVydHJhbmTvvIzmiJHl
nKjms5Xlm73kuIDlrrbpooblhYjnmoTpk7booYzlt6XkvZzjgIINCuivt+ihqOaYjuaCqOacieWF
tOi2o+iOt+W+l+mBl+S6p+WfuumHke+8jOivpeasvumhueWxnuS6juWcqOS4jeW5uOS6i+aVheS4
reS4p+eUn+eahOWkluWbveWuouaIt+OAgg0KDQrkuIDml6bmgqjooajovr7kuobmgqjnmoTmhI/l
m77vvIzmiJHlsIbkuLrmgqjmj5Dkvpvmm7TlpJror6bnu4bkv6Hmga/jgIIg56Wd5oKo5pyJ5Liq
576O5aW955qE5LiA5aSp77ya6K+35LiO5oiR6IGU57O777yaPiBiZWdhYnJpZWw2NTQzQGdtYWls
LmNvbQ0KDQoNCuaIkeWcqOetieS9oOeahOWbnuWkjeOAgg0KDQrmnIDlpb3nmoTnpZ3npo/vvIwN
CuWKoOW4g+mHjOWfg+WwlMK35Lyv54m55YWwDQo=
