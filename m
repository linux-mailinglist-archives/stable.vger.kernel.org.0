Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB928BD5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfEWUt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 16:49:29 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:36031 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731460AbfEWUt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 16:49:29 -0400
Received: by mail-pg1-f181.google.com with SMTP id a3so3747208pgb.3
        for <stable@vger.kernel.org>; Thu, 23 May 2019 13:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=BQAwLzyZHUTUA9C3I6GaYYp03v/RFuFPqVYAXDj/LaE=;
        b=aKawysc0V3G9cMZQs9o9HXnwZZG4jR8E0LAYted1+NjTq3GTsEvPNFXMDLsKCGfhLg
         DpKyBuoUNFmGK+7ATsRp+BLmC3U401yuvEaGgzpqekXN6TH0re2YAMpv/kdzHfX9dvRq
         tcwQ4skXKrRKlr8eKZapFsDEITLAMOOnu6XzOe9kv3+5JmCfSQj3kssU9wH2Mo6w44YL
         xCT95P/aAys0PXzQqXEdg9AR0383BpZHVhyMr4V9yi9JoF3QUyMju1ymrepiYnejGZcO
         /5dKjXa/MvGM3qf72OdyT5ZkzToG/l/ogbAyZMPGzNIa+kobEfk7YQgpTMPFimwz5bsG
         Re2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=BQAwLzyZHUTUA9C3I6GaYYp03v/RFuFPqVYAXDj/LaE=;
        b=VejaX05k9qZYVkXxzAkpNzPvUDMDAZayo1EIOkzjyVEdzQT04YvtC6Tp8wyyHe0YDP
         72hqPsdK+fO5M9y2/pxc1+StocI5S6BbbPc3BoE+xe0m7wNy0OSmCaU+LsXJmVe65FRU
         BZ4rsQ4GrFcm96aN1oA8tjhD5E9jZCgPDZH3mqS9vYiWLwmqaYjIrH2WVwlIpqlxqb0W
         Ng1Hg31ns6AWGz1/dmLiwRFfjWXO9FfgHXm33cp7rSONwnv2uzvZrD9qisQzuVibnp5Y
         87O229SpFuMkflhCNkXNbjeqjNh1IbNABpo9QBRMfO2X09EAa5dVVZ5DXr6ei2q2183V
         npPg==
X-Gm-Message-State: APjAAAWhUofj77rCBvTL2uNQEVnNt0Vx2EbRHkWMRm9MlCJNWH2qAyQo
        5UMQgNb2Xgkb3LJdXTfHHOTA1w==
X-Google-Smtp-Source: APXvYqw5Pck4d1+xCnVCIAOEFNCMYuRkWYzl/96/Hj2JFfsn1S6gWQ4S5fh3P8WJVWvq0lx9Zys4qg==
X-Received: by 2002:a65:530d:: with SMTP id m13mr5564193pgq.68.1558644568127;
        Thu, 23 May 2019 13:49:28 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:0:1000:1612:b4fb:6752:f21f:3502])
        by smtp.googlemail.com with ESMTPSA id j97sm210977pje.5.2019.05.23.13.49.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 13:49:27 -0700 (PDT)
To:     stable <stable@vger.kernel.org>
From:   Mark Salyzyn <salyzyn@android.com>
Subject: Please cherrypick 592acbf1682128 to 3.18.y and 4.4.y
Cc:     LKML <linux-kernel@vger.kernel.org>
Message-ID: <6f545e7c-fda8-4bec-33fc-283ebf492372@android.com>
Date:   Thu, 23 May 2019 13:49:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cherry pick security-related fix 
592acbf16821288ecdc4192c47e3774a4c48bb64 ("ext4: zero out the unused 
memory region in the extent tree block") to 3.18.y and 4.4.y

The cherry-pick is clean and requires no back-porting. Is already 
present in 4.9.y+

Signed-off-by: Mark Salyzyn<salyzyn@android.com>

To: stable <stable@vger.kernel.org> # 3.18.y 4.4.y

Cc: LKML <linux-kernel@vger.kernel.org>

