Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9342A5679B
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFZL3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 07:29:53 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34985 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZL3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 07:29:53 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so966020ioo.2
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 04:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=gFMVIe7NOJxKZGgJT7rWYmaSfb7XYTdm46vTeWYUguM=;
        b=MSJPGnFPeeBR11+PMYhYFpnQFcMAyqErtz6NSeOM5KQAC48fz+b9UwkaT4pXGkbiAb
         iR5f71mK9kKttoJ1B+qSQrP51XUQrB3kl3BwTkeJ/7B4K1Zd2ioRkQnjBQ17yW5ytKkz
         pg0C5s58nQ00xRJzoremV/1Cl5cDWmmxW197vxhM6AhQnlcEwC53eYtsi6Y4hLNRXd+4
         0cC8w9+gYmYEewYbQFI9SIDDCiUt2FNRwgttH+lPtBWHWPUKjofi0x7OnBOjXCfRjfnN
         +6agtCeiV0EGEfNHHpHssZDtIcG+Cc52MlS+ds51WrXxQSEOij0DNz/uqBd9zQNkpUCZ
         ql2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=gFMVIe7NOJxKZGgJT7rWYmaSfb7XYTdm46vTeWYUguM=;
        b=HOSKabcaSpi7W+AquRhKIgzg0Ju+6Jm1ESMmQq4/30QLGkFx9SueJJ7jEbCN7EamyM
         D+vCorweuOX0FpDvUs8q10dTtSXZY7X51A4ruC+pcekNVH2v4JJ5djIrRe0uhOsU+33O
         UelyVHUpg3v//PPfivTLAogWtNWeeA0AuileL5/7+F8Z10A1HbQN3JfYSoumReWm4OcQ
         4LNUUk2XnnRTuGlARzbIXIQynPuyD8hnHDMyuK+b32Zb0gvR1cZ2siei0iwrf/zzf0OO
         Vugzc8wFyCsLlgwFNOWKCrIdtd8SX2GaWH4EE6X7BBJl3ae3QWY9kurQ8QlGSC1Xx3gX
         TNLA==
X-Gm-Message-State: APjAAAWo7be5seoO2ibtt/1T008CySoGzyKykhN7wTYu1mVgfsrkydR0
        1xftHVRLpti90hkpd+QoAPVC/NiKZuO0ABTVzQc=
X-Google-Smtp-Source: APXvYqyAFgrA33vGVpf3WvHzHfaWLey+aMJDP1g3kc44f8ZP9FKTVkr6u6Q29iKtPSa0OZtlq5W6m/eZxsU5i+zNBWU=
X-Received: by 2002:a6b:2bcd:: with SMTP id r196mr4490556ior.73.1561548592903;
 Wed, 26 Jun 2019 04:29:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:8cc1:0:0:0:0:0 with HTTP; Wed, 26 Jun 2019 04:29:52
 -0700 (PDT)
Reply-To: alvessarment57@gmail.com
In-Reply-To: <CAJrA_CxZkkV8kQqb6Da4afnZNF-saiLCi1wtoLg__RL5kD4WhQ@mail.gmail.com>
References: <CAJrA_CxZkkV8kQqb6Da4afnZNF-saiLCi1wtoLg__RL5kD4WhQ@mail.gmail.com>
From:   Alves Sarment <alvessarmento9@gmail.com>
Date:   Wed, 26 Jun 2019 12:29:52 +0100
Message-ID: <CAJrA_Cyq=ZaBKMrDH9RQ73V75B54F_g5yhR0mALiH4YxHBtVgQ@mail.gmail.com>
Subject: REPLY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sIGdvb2QgZGF5LCBuaWNlIHRvIG1lZXQgeW91LCBwbGVhc2UgY291bGQgeW91IHdyaXRl
IGJhY2sgdG8gbWU/DQpJIGhhdmUgc29tZXRoaW5nIHZlcnkgaW1wb3J0YW50IHRvIGRpc2N1c3Mg
d2l0aCB5b3UuDQosLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCws
LCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCws
LCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwNCg0K0JfQtNGA0LDQstGB0YLQstGD0LnRgtC1LCDR
hdC+0YDQvtGI0LXQs9C+INC00L3Rjywg0L/RgNC40Y/RgtC90L4g0L/QvtC30L3QsNC60L7QvNC4
0YLRjNGB0Y8sINC/0L7QttCw0LvRg9C50YHRgtCwLCDQvdC1DQrQvNC+0LPQu9C4INCx0Ysg0LLR
iyDQvdCw0L/QuNGB0LDRgtGMINC80L3QtT8g0KMg0LzQtdC90Y8g0LXRgdGC0Ywg0LrQvtC1LdGH
0YLQviDQvtGH0LXQvdGMINCy0LDQttC90L7QtSwg0YfRgtC+0LHRiw0K0L7QsdGB0YPQtNC40YLR
jCDRgSDQstCw0LzQuC4NCg==
