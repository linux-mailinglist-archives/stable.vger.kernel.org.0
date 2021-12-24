Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A616F47F0C3
	for <lists+stable@lfdr.de>; Fri, 24 Dec 2021 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbhLXToa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Dec 2021 14:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbhLXToa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Dec 2021 14:44:30 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D191BC061401
        for <stable@vger.kernel.org>; Fri, 24 Dec 2021 11:44:29 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i22so19015772wrb.13
        for <stable@vger.kernel.org>; Fri, 24 Dec 2021 11:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=UtoF0r4yG8U/T8UOLxn8dacSd49m7zi2Qvhr7fGOaoo=;
        b=EGrJakmfwr7CSfCw3iiWczN15rUsWTJw+pq76/pv9vHCFpLxauBPfX3arCNKgLRas4
         fvk650yIGztwCZhOHSMxVtj3m88fSfLeBn8qUh5P5QMnbC7dviiYyg6yUBcjLhjOmL6Z
         jPskv6kq+hvoPqMcCqMOj0VRVdsrCWuiRdfx6pbZHsHIBHaklbo9N3K/H07H71XjQ56S
         eK2xfEUwn8L3lWS6sW1B1Y4U1sCRpIu9p6PaaoYwodpK8Lf4nUecoXu5MKocmFMLJ8Sp
         ZAbA1nIV5GkGE/uFFPHv9rU8+VJmAkGiTGuX6+gY/AtYPlHZhYmtwVPenTWxHZJtXFiz
         LOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=UtoF0r4yG8U/T8UOLxn8dacSd49m7zi2Qvhr7fGOaoo=;
        b=8PUDXtDqFU225pX/m4P49/DyvhSD9dzX9gqb8kT5lcWdruiSibUcT8/KmfgDQZFa4c
         VHmgM4tTJYzH7BD2YXEccA8ZEkHrV8UCdh4vzewgbluu4mG24vD+qrw4NBbVSsI7pM/a
         lFypGNNHJeHfswOCRQvyjYvEOLzin/lQQRW2coZ666fr4nLmv7yDXYuWw4LhuQUcHxXq
         8Gsu6KAgrqmHuR+U+7vzPb0w8dO7xJeCS+4KLOIZ6a2W+RrHnVsUYEC5WyoufJ6KX71Q
         ZsRQzh0pluIk8Zh+nIYnGIt3MhfKYX3q87wKTAULO2q9tq6ErURw1jBYvJzIyiU7A8wV
         BgMg==
X-Gm-Message-State: AOAM530ZE0+CroyTPnhZV331DAcpfZdLY8KuhSKmTTl/9y3HdfqA+TXV
        owjqpUifzpjuRhVQSOJeTz0=
X-Google-Smtp-Source: ABdhPJz7cZKfjQpAtF8ssuD0dXSzDyXQESZDD2oJ86UKGfKRQvDlZIzSgwPi7B3zMsiv8nHWxHdYTQ==
X-Received: by 2002:adf:cd85:: with SMTP id q5mr5581043wrj.80.1640375068422;
        Fri, 24 Dec 2021 11:44:28 -0800 (PST)
Received: from [192.168.9.102] ([197.211.59.108])
        by smtp.gmail.com with ESMTPSA id y11sm10359925wry.70.2021.12.24.11.44.24
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 24 Dec 2021 11:44:28 -0800 (PST)
Message-ID: <61c6231c.1c69fb81.1469.f5b4@mx.google.com>
From:   Margaret Leung KO May-yee <kurtatgloria890@gmail.com>
X-Google-Original-From: Margaret Leung KO May-yee
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Gesch=C3=A4ftsvorschlag?=
To:     Recipients <Margaret@vger.kernel.org>
Date:   Fri, 24 Dec 2021 20:44:20 +0100
Reply-To: la67737777@gmail.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bin Frau Margaret Leung Ich habe einen Gesch=E4ftsvorschlag f=FCr Sie, erre=
ichen Sie mich unter: la67737777@gmail.com

Margaret Leung
Managing Director of Chong Hing Bank
