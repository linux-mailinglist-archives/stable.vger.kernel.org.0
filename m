Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863D01F8D49
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 07:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgFOF11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 01:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgFOF11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 01:27:27 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2084C061A0E
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 22:27:26 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id p5so15623303wrw.9
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 22:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=+sNId/cOxmCQhSwi75v2wBrz/HgFTOTF9LF1huXdjt8=;
        b=rGo9q+6UfjbtItoPPX850b2Mpeoqv/USSPAZSRYVsHU331UCXS4u6NcJrfSe3I5d9T
         DS8hrwc0rQBDelhTY2NR6k1MdC1wqGhMLSeuuCrqBosPaHjLPdIF5nP6aaoM8u82erRg
         nKLMl6QpAA+EOoXkTZBmW8DVsiZ941fYaeXixqfJQcZlgfsH8Vg06IOyRzDIg3hY3D0P
         81uMvP6vk/zWcOSog+RJwB4s47dNLW1y7y1rBGMfnBUhLdFwbBXTT0u1uk4yBy/jl/E4
         vn9oyYNWKomPHevEJHPEJtmKLoUGYYtICX2phaAxbPpaJd3V+yZsMTGZZZ69sn1y3aLA
         cVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=+sNId/cOxmCQhSwi75v2wBrz/HgFTOTF9LF1huXdjt8=;
        b=RJAC4efsUi3P+b0mpq8yqBkHWiV8d+y3xnADu5DIEPJJ4+8ZDHbzoHpFYbuC9EcNCw
         Kncuu6iKB5eN/NGLilq/DbKkd/oVU4UFlxqx8J5W9YQhWWVzsVOdNTIQpPLqaC/rskry
         YWo4ckA+znJAYlmLXuutdpVSa6jBSJQSNPLh2LA4PR7NgHUUj1B0o5hsBW6mepxDupF9
         c/8W0DkJp381Cu6HXsqxUYGi/WwRDQmSkz1SJ9hIqqACF2cegnLeOjhQqfjHQoRNbUgr
         maMXs2txjKROY9z+gli9DaKqdNuDfqJT6YyMBOiKO91j19hQG2vdapt0btJLX8hFu5FW
         peUg==
X-Gm-Message-State: AOAM530TeKnrEw0e/xEWB45IwYodGvCUMFX1YSdzPdgLZqHT0/c7IHrb
        Hkm/DjI1kN5n6zRRls3oxNjCa5ytu5k=
X-Google-Smtp-Source: ABdhPJxHFCg94h5pf8aHCw6Z1KkjE0Ranz+1ANe+MaCRutKVeDcKobTEWUbuY8RLM2TIlGdJmeCwsw==
X-Received: by 2002:adf:f789:: with SMTP id q9mr24496972wrp.251.1592198845223;
        Sun, 14 Jun 2020 22:27:25 -0700 (PDT)
Received: from tmp.scylladb.com (bzq-79-180-108-152.red.bezeqint.net. [79.180.108.152])
        by smtp.googlemail.com with ESMTPSA id y25sm32002615wmi.2.2020.06.14.22.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 22:27:24 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Avi Kivity <avi@scylladb.com>
Subject: Backport status of "aio: fix async fsync creds"
 (530f32fc370fd1431ea9802dbc53ab5601dfccdb)
Message-ID: <a88009bc-dcea-eaee-7fe9-943bc8aae781@scylladb.com>
Date:   Mon, 15 Jun 2020 08:27:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit "aio: fix async fsync creds" 
(530f32fc370fd1431ea9802dbc53ab5601dfccdb) was committed for v5.8-rc1, 
but I don't see it in any stable branches or rc queues (it is marked for 
4.18+). Did it slip through the cracks? Or is it on some other queue?


Thanks, Avi

