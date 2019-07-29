Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E179792CB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfG2SIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:08:32 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:45416 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfG2SIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:08:32 -0400
Received: by mail-io1-f47.google.com with SMTP id g20so122062037ioc.12
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wRLwKGBtKJgQRLSmh+F3xXu7JBlNIu4QQFNpHbu2Ff4=;
        b=c4KkeQj5VjmA5khJokvbWr6kywseiA3bfz/sVUzHkHGLd1F0t5mBaxyM1vYBk4GExU
         1I2b1kycQmHNxEXAhI4Rde+81esanYKbEYIVon28G9640rBpgwbNo3q9HN5QR/Ae2bvK
         JUafPq7Niz4iQSSTMKG2vPZ1AKpOOCWg86FPLBlBj/T/crdsXbhgnzhc0xuT1nGiIVbK
         oqbHr462eKzjd31GHoDd3i1RfWwH1t+mobhqb6JsqpW4Mw+7NKER/Cx0lb5HXKp64MxH
         B7KW7sPjb1hYM4C7SDWc22fx8xpyTwDk+s+Q7d5wjJan1SWDI8Nx2Esv2iBp0yJri2Fj
         Lgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wRLwKGBtKJgQRLSmh+F3xXu7JBlNIu4QQFNpHbu2Ff4=;
        b=qLfS2XfmE8s0X8OUD5AyMa5eiTvGjlVWXPzkHYtT00eXxPZ81KvErK7aCDQXKsg+2k
         TxarU391R3p7mshnuEuTCxRntqom4uYXTHfp+LgS0Xe0elQewruiz0jGTHIcPqf5ddtA
         mnXgqu3Iz8ZOUw6eJQCtIW5ukxoEM32Yrl8QBPkkO0wa4LVKL+8pma+yP9yzDdvoX/NB
         63HPrLfdfOxWkQIsI9WVH9MPgm3LYIhZaYUtcCzsp/rlyS5lYxhOQty4d83YGcVYRUVH
         lrreT+lFED3Gl5UihOpIys+575TuG+JAssQVocizGYOaHrpF9WDsOavIW6j8GRHbd/cN
         A3ig==
X-Gm-Message-State: APjAAAV+ImasvfxOO4OwqRrX29+VeHnfHvx0H3FaYTH0qy0FBPzqrJnC
        mZBxWvt7Wdo959/4mcFtbFoxtTElwW4=
X-Google-Smtp-Source: APXvYqxh8wP0QXO0eqZ4vwuLUAbuXpnFzWFWwADzQH82/2KQfOvCIkVGXXGNxdRdjJPN6u2C+uc+iQ==
X-Received: by 2002:a05:6602:220d:: with SMTP id n13mr4934136ion.104.1564423710451;
        Mon, 29 Jul 2019 11:08:30 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v3sm6595284ioh.58.2019.07.29.11.08.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 11:08:29 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: fs/io_uring.c stable additions
Message-ID: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
Date:   Mon, 29 Jul 2019 12:08:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I forgot to mark a few patches for io_uring as stable. In order
of how to apply, can you add the following commits for 5.2?

f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4
c0e48f9dea9129aa11bec3ed13803bcc26e96e49
bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49
36703247d5f52a679df9da51192b6950fe81689f

Thanks!

-- 
Jens Axboe

