Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E85450DD2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240341AbhKOSIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:08:02 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33515 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239141AbhKOSBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 13:01:19 -0500
Received: by mail-pg1-f176.google.com with SMTP id 136so10597897pgc.0;
        Mon, 15 Nov 2021 09:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f6pGxvlWDiR0ktlk64UQrKY7yANUCgJE84uRs04H3yY=;
        b=jJkS73wvbVJIa3gSme2JqxSX0jKlzyhaNdDkhYqtvRUKnXsrG+/2GTWCFQXlOYWIKd
         AemhlFWY6VTpO3cbclVwpKMfz6EDLDUz3xSl66suaeLxdc4E7Ie9VJG+coEAxfEtZ7Dj
         2tn8uOcu0MrlViZu+i6wDeW17CvDEAYOLhQgbaGumJfC4jyqvHtDFkqN6QXw8L4ZtCRL
         Wzxjo0dTd0HGuW3zJtVl2Cf4xgcvAacNyJc5cxq+UlP01IAu1+huFEnBGdfuesIhuvH1
         lv9AzxEeN6o0yTerin4ro8eCuU3LrvUqQUnotrAUYok8NVYAys9phWVFdjehwfdAFH6Q
         epTQ==
X-Gm-Message-State: AOAM530cPkjleW8NLKfzELw/75A4Cx1nPhQ3aIk0b2TZWHFtasbQ/Fga
        pfi2xyNhWRS9XtIOcWUgdoU=
X-Google-Smtp-Source: ABdhPJxhPbXXAmQ2obiiSEJL6w5Iukm9mTS1wTuvJZntMTAOgkbxXkvj4aX8QvB1I6BZAqeGq/fl8Q==
X-Received: by 2002:a05:6a00:158a:b0:49f:be86:c78f with SMTP id u10-20020a056a00158a00b0049fbe86c78fmr34818214pfk.56.1636999100921;
        Mon, 15 Nov 2021 09:58:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id w1sm3308265pfg.11.2021.11.15.09.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 09:58:20 -0800 (PST)
Subject: Re: [PATCH 5.10 011/575] scsi: core: Remove command size deduction
 from scsi_setup_scsi_cmnd()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165343.996963128@linuxfoundation.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7ed36c27-a150-39a6-d8e3-483c76bbedc5@acm.org>
Date:   Mon, 15 Nov 2021 09:58:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115165343.996963128@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 8:55 AM, Greg Kroah-Hartman wrote:
> From: Tadeusz Struk <tadeusz.struk@linaro.org>
> 
> commit 703535e6ae1e94c89a9c1396b4c7b6b41160ef0c upstream.

Hi Greg,

Thanks for having queued this patch for the 5.10 stable branch.

Do you plan to also include commit 20aaef52eb08 ("scsi: scsi_ioctl: 
Validate command size")? That patch prevents that the bug in the commit 
mentioned above can be triggered.

Thanks,

Bart.
