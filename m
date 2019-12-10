Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D87118C4C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLJPRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:17:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34075 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727211AbfLJPRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575991033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MlNBgL0ugxMvD0K4t/98VXDt3fuZdMt52QzJ1cdBJFU=;
        b=bvr9fNgCY0LGzuDWZu+B3VQ9ayYdlms6d/gocXhQTnKJpqt6Y3+3i3pE5rXY+8JMasV0xu
        8HgMf/51yLZne7fwrOed3ROIPlmoRQxXstvGn7k4t2Q9tOZjIrEwfrOHfxTP5c0tNtNyij
        bqXO9ePFpkwgz0rM3iv4M0W69KQxZXo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-xgX1fal2P4qHSN0aVhxFEw-1; Tue, 10 Dec 2019 10:17:11 -0500
Received: by mail-qt1-f199.google.com with SMTP id x8so2091117qtq.14
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 07:17:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MlNBgL0ugxMvD0K4t/98VXDt3fuZdMt52QzJ1cdBJFU=;
        b=uVFfLcZxEjWSuTyUBlzA527BTPTim/wIF/uFxW7CASeH6+KnM1EaGrJ6AB5NjBQrSD
         dtVbIyoMhN2jX8G6+BYqY11KSYKXUEfZQHK6+2xEGIIhwam2V79TsFU9ajAFIlRaM+iG
         Gr7kK6gXx+p0UN1azhun+cmFM2OewhafWhZi69o8rS9mTbeP3akqD6wA9WK9Ni3gTHgq
         CfT3gGMhWE7u1aPsrAcWsUSpDaUNkPQoHrY2TVOydGIeVkyzHeYmiWvTStM2xMvLTio+
         fVMmdSZeeYA4y9LUK1hZAN4JyzOwR6uWup9IalolhECwuNA/916K3IgBY6+RN0LH09Bs
         JAOw==
X-Gm-Message-State: APjAAAXkvnV6Q2wZLhgyW5ypFLUkzUQ177svAJMXSmD5WmVHQXlhc7RT
        i10oYl3kVWYA6yJ3ko6YLwXSqy6ygKuQV3RQNI4L5y1nCGxqvI9lLKCPXPOUnSPCypAA3oGp9aW
        kzOpMReUmjtBEspie
X-Received: by 2002:ac8:2c77:: with SMTP id e52mr28965268qta.312.1575991030561;
        Tue, 10 Dec 2019 07:17:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDZ4ES/VaU+ai/0vekOfQm7BOuAL6iXKLZyvxAKxVvCaDaVNGZAabPWOX6rZsaaqCynLHBlQ==
X-Received: by 2002:ac8:2c77:: with SMTP id e52mr28965238qta.312.1575991030257;
        Tue, 10 Dec 2019 07:17:10 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id l35sm1235781qtb.42.2019.12.10.07.17.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 07:17:09 -0800 (PST)
To:     stable <stable@vger.kernel.org>
From:   Laura Abbott <labbott@redhat.com>
Subject: Requests for stable inclusion
Message-ID: <54f071b9-ab38-156d-dc3e-6a6b3959ccf0@redhat.com>
Date:   Tue, 10 Dec 2019 10:17:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Language: en-US
X-MC-Unique: xgX1fal2P4qHSN0aVhxFEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you please queue up the following patches for stable 5.4

cba22d86e0a1 bdev: Refresh bdev size for disks without partitioning
731dc4868311 bdev: Factor out bdev revalidation into a common helper

These fix the issue reported in
https://bugzilla.kernel.org/show_bug.cgi?id=194965#c46 and
https://bugzilla.redhat.com/show_bug.cgi?id=1781762
They apply cleanly to 5.4.

Thanks,
Laura

