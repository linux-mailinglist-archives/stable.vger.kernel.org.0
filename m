Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18224183263
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 15:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCLOHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 10:07:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43274 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLOHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 10:07:08 -0400
Received: by mail-io1-f67.google.com with SMTP id n21so5751925ioo.10
        for <stable@vger.kernel.org>; Thu, 12 Mar 2020 07:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oCQZrJERoMLVJX5x1RC4/10D7o7Of6OtemKn4HOrLdo=;
        b=HZBmgujyPwgpUWYM7/HORgiCG38xaFHF4dYp9PfcCMwQa+VsSrfX1QcCEV2O/gT9vK
         B22yMEuG1CTTNBqtIWim7JaRHZbNhqTEyNTkewt4OlSchidYGqNM+X65o6BmOlfKKdWJ
         vFUIdRFg27zaJ17A5rcanFIFhmm7tRiYuYDLME0juq80YONBxlRydi7cp23gx7xGnPS3
         5rJTQNK5CjmvMY4T9Sbi5exCPfZBvZpNO8MVzLXVYCky0fr9MbFSRN8OvuiVYcfIqrgl
         m2sraVlEwzs3T2Ku8sZdFVk9PNNSoe/6aBqiEaW/dlyxt/iHPTCHRezZ4zKu7YdhfszQ
         V48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCQZrJERoMLVJX5x1RC4/10D7o7Of6OtemKn4HOrLdo=;
        b=R3sKn6sIn3bwWV2gg37me4ap1eOUSNDV7JlWkoWVmC7lpyUNouT4CyZ9rWPFXg3SQZ
         oF6qZy0dXyZTj+NIZy2x7zDJEojsi5z0Xrn/0UBKgS21HzDHoWfzDcaioVtVt+lvcRY9
         jYpwMduKNqmY29hk5iDt4BS705S6M+cxF6VrVmFq4/AqxMikglw6bNXQYQmvs+PoAb9z
         qebk6Sq9UlQGVxu2iVNgdg4b3X0MjHODpvg9yYIC433gB1vQDord+h8PvUyGEroZXS5A
         VKunArE99FQ3fMpu9FdmUvt+jF2CnCmrTES00DcpPf8LOZ559IZvcIfQOCcOf2QDpga4
         mH6w==
X-Gm-Message-State: ANhLgQ16IVU2eQu43+xuHROCM+WhSD9gOahn8ARpa5J7VeJtZO88kxI0
        TWfaFT42cYanVN90JiEL4nevLw==
X-Google-Smtp-Source: ADFU+vtKS38s0PCAkBWNDJM2Ky4G6/1a8TBXyV4tWFrtvcbpgq9gguaRafM1XlKHiVjI2Je1z3pj3Q==
X-Received: by 2002:a6b:f118:: with SMTP id e24mr7955975iog.54.1584022026659;
        Thu, 12 Mar 2020 07:07:06 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l6sm193178ilh.27.2020.03.12.07.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 07:07:05 -0700 (PDT)
Subject: Re: [PATCH] ahci: Add Intel Comet Lake H RAID PCI ID
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable@vger.kernel.org,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200227122822.14059-1-kai.heng.feng@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e471538-0d7d-534d-6de6-27213cfb36d8@kernel.dk>
Date:   Thu, 12 Mar 2020 08:07:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227122822.14059-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/20 5:28 AM, Kai-Heng Feng wrote:
> Add the PCI ID to the driver list to support this new device.

Applied for 5.7, thanks.

-- 
Jens Axboe

