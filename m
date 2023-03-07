Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B236AED99
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjCGSFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCGSF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:05:29 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C72698E88
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:58:26 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id y11so15034738plg.1
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 09:58:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLBHmJfnrJpN2/BeQiLegODr6r/XtN9ZTf564gwPeRE=;
        b=OZuv2yE3f2dJqA/1HVq7WYaezSgYAoOMK5VbtSd9WZNRPdnmDuJ3WuVoG/aOkYdeuC
         lkIOYaCd5IElUMkr0VN2nS5Fud3XDxcpFunqIfiuR+ISRUTzez3DwzIHa48k5vq4mjag
         Qgo37yaok+4cHlspzkBrdJSIgL1a202AKGCk2tpF+SfKxjXuyhJOsFJ4taKkznlN6/7q
         1EMmABzKDZ5uUCnE1fntIRwqBYJKZ+8cDyTh5rmJD0DmdRAMHN75FiQNEqS084aGi3Bq
         whJzpm6uK5I5qfFOI6YkNlSZz6DiVKK+20KqnDevL7SSVtrfxeRgHvLa/3pKQKUVy3TD
         FYgw==
X-Gm-Message-State: AO0yUKV61s/AK8mWE5V5VrBfiRxQq0c7i3mG3BfQhg7iVI5L2fduHbMO
        dszq1M+Bl1zhYfTXYQtV9AI=
X-Google-Smtp-Source: AK7set8zre6vcOCIFYfZQQH3CBoT1NkpHzT08x8Yp1nQNyQxA0dogkh/FNr6jlGsHJZLHTfmfUpQ4Q==
X-Received: by 2002:a05:6a20:12d1:b0:cd:fc47:ddbf with SMTP id v17-20020a056a2012d100b000cdfc47ddbfmr17185915pzg.47.1678211877038;
        Tue, 07 Mar 2023 09:57:57 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00582f222f088sm8190079pfi.47.2023.03.07.09.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 09:57:56 -0800 (PST)
Message-ID: <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>
Date:   Tue, 7 Mar 2023 09:57:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 0957/1001] scsi: core: Remove the
 /proc/scsi/${proc_name} directory earlier
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170103.699105440@linuxfoundation.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230307170103.699105440@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/23 09:02, Greg Kroah-Hartman wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> commit fc663711b94468f4e1427ebe289c9f05669699c9 upstream.
> 
> Remove the /proc/scsi/${proc_name} directory earlier to fix a race
> condition between unloading and reloading kernel modules. This fixes a bug
> introduced in 2009 by commit 77c019768f06 ("[SCSI] fix /proc memory leak in
> the SCSI core").

Hi Greg,

This patch introduces a new bug and the new bug is easier to trigger 
than the bug fixed by this patch. How about waiting with applying this 
patch on any stable branch until the fix for this patch has landed upstream?

Thanks,

Bart.

