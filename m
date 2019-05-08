Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412CE17AAB
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfEHNcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 09:32:54 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:36394 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfEHNcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 09:32:54 -0400
Received: by mail-pf1-f181.google.com with SMTP id v80so10516252pfa.3
        for <stable@vger.kernel.org>; Wed, 08 May 2019 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i6KS9K8YpNwUrQapANmjwIt52Go0BCHUmMKsRmbM3B0=;
        b=QpIDRydvaW12ZorOMOelcE9J7uqffXTR+jukegx3WityMv3FHaqU0JSlzu99TU1+/g
         1p0NoNvPsWhuGY33dk5X5vooF7sx24OGn7STdd2t8N9FKP9mWZRp+a1n3FWKzLRADCW9
         b1pDsl0IX14TIpKJJBlRqxRT1WPAopAkokJ5B4XkVDX3gSwG+fdOlitaXW+ERi+hnDIs
         kd2RaNy7rYWBG02mzTs+1Hh0+X9RvRIhUA8kHAcdnNMHpWs5aNsAsPuLM0iMWPEGT0El
         F+39LPZQplzaA8xYd4/hf3E0K3LfpHefkEunH8Rlt3ZPdY5eSCruC9WkOOpGMQB6Hmov
         +TBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=i6KS9K8YpNwUrQapANmjwIt52Go0BCHUmMKsRmbM3B0=;
        b=rIBatAteir6Z4OUpqKIRLRBmmYeWIhohFLCv2P4zwZjPDOrGnbbQcAEMbEFhQWTVOv
         Ys4FgPKXkFxdMF8I/OBgH8XI9U2nEZf0ANjda+PT51HbXx2MUKMD4yDnUoQsxqJVYq4J
         mtaTpdlO4pNhPrHVX0z1wunjKFBo0okGTs97vdNhaINJcRjdEemW5oNhMxbxWT9CfAX3
         q9kkvDlUmUkdbb6NRvavqvbCWgd3cHPJVi2YLCr+7StknliHCNvLVVphBqGzqXzqZbgr
         VGRb4PuuB+MYgFgNWbUtPv34JTwij2bcP/D+5ODaLI+CTh9LW6Wpmmp/Q81jNnKJZYQ8
         TNbg==
X-Gm-Message-State: APjAAAVX5FYZtLYJOWXvNAKdAvn73U9qRkRvq4+jIr3NfUwOb930eH7D
        yJTDsXmbzzRTUJK6Pc1MIZhlz5A2
X-Google-Smtp-Source: APXvYqwFKcrxp2dTAPlI8Z5XOEW0zKRhm3qwT7IO/9GVUN9OivPXculFxNLXZ5RP5+W7kWIXZh/Yag==
X-Received: by 2002:a62:b602:: with SMTP id j2mr48532695pff.68.1557322373655;
        Wed, 08 May 2019 06:32:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d15sm22064572pfr.179.2019.05.08.06.32.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 06:32:52 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commit b90cd6f2b905 to v4.19.y and earlier
Message-ID: <41f58f37-314b-2f4e-441f-46961a2d7b88@roeck-us.net>
Date:   Wed, 8 May 2019 06:32:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b90cd6f2b905 ("scsi: libsas: fix a race condition when smp task timeout")
fixes CVE-2018-20836 [1]. Please apply to v4.19.y and earlier releases.


Thanks,
Guenter

---
[1] https://nvd.nist.gov/vuln/detail/CVE-2018-20836
