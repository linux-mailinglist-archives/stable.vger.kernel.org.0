Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7298120896
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfLPOZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:25:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727579AbfLPOZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 09:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576506311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MTKpPlVwIBujqq4Qqq6wiAtKLmkL1V1kAblZmfWfz94=;
        b=Wv4hSJIhamZmd/Yo1HOa3/fS+d2n0isamlLzkyuUq8Gdf586ithFTTZkZTy3k2E9EwQpMY
        6C4KUd/kcJU+jmTxAOTdJMfV9vkG1MVcef95UCDuKb2TdNDl0eCYuad5A8aSfF0aXBQsDZ
        2m7fL3o1/mENyjvsH/7qiEV3Y7qK1hc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-oyeLKZlzNfe8mUwS-yXMAQ-1; Mon, 16 Dec 2019 09:25:10 -0500
X-MC-Unique: oyeLKZlzNfe8mUwS-yXMAQ-1
Received: by mail-wm1-f69.google.com with SMTP id 18so1112448wmp.0
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 06:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MTKpPlVwIBujqq4Qqq6wiAtKLmkL1V1kAblZmfWfz94=;
        b=czP3v+Cgrz3HRqQzAAkTm3hoJlFIB4oWLRbekJMFGvsAALgH3/kAcDM+6PQ38MPudm
         7i2nrOKYB1hv0myC0wMRZx4H0KLard5BbphQib/rpAGw8HJqdY3X4ZCwxO5nlEZ/AenO
         xdkWdGJBVjBsmwl1/EhOUhNQ/Lc6espUwspSf4u6t6/k6JrgkFNYzpnGc8tvUIyM0U5L
         yy7DaAlpCVBrZItKR+xCuKRjWCKCXmS9kf0fcMHmnqtK8L+f0L563JukLA+nAJX+m4DP
         DnrQVxlrjShVGpCXFxhSMgO4MXnT9PcYTk7Jpxu4uHOwfxZ+bgs7uZnwK5ztxGNtdlKC
         hEJg==
X-Gm-Message-State: APjAAAWjUJEAbPel4eAUqaBN0MqMi5PmR5sAksRDDJNqkxT0iCN7FCgv
        TWJmXN+/7/SccEXKgenCq3l8vb6N3j4tYSVqx7GZ6W+R0DFKH0LIAvPh8PUl1GPTNdj/Vo4ZzaC
        0oxhodJsc5P5585xhM6KT1y841JPXJu7x
X-Received: by 2002:adf:fe07:: with SMTP id n7mr30981607wrr.286.1576506308967;
        Mon, 16 Dec 2019 06:25:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7DU4IAfqtL59oZgtZ7WlCnJHGcv2eAynSkTRfNOUKtpngZ4TVtHQbV7nY27qzZpkDErx8BjmnaKEo2H0vX30=
X-Received: by 2002:adf:fe07:: with SMTP id n7mr30981589wrr.286.1576506308834;
 Mon, 16 Dec 2019 06:25:08 -0800 (PST)
MIME-Version: 1.0
From:   Major Hayden <major@redhat.com>
Date:   Mon, 16 Dec 2019 08:24:58 -0600
Message-ID: <CAD3hnWh3xcADADtiGvBRRu3857s8rDXPm2x6oct+ZBaM=ACQnA@mail.gmail.com>
Subject: CKI outage impacting testing
To:     Stable <stable@vger.kernel.org>
Cc:     CKI <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello there,

Some of the critical infrastructure that is used by the CKI Project is
currently offline. We are working to bring it back online and resume
testing, but we do not have an ETA for that right now.

We will send updates as soon as the status changes. If you have any
questions in the meantime, please email us at cki-project@redhat.com
anytime.

--
Major Hayden

