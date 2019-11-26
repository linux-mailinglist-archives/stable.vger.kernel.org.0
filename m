Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7589E10A5AD
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 21:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKZUzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 15:55:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37562 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 15:55:47 -0500
Received: by mail-pj1-f66.google.com with SMTP id bb19so5297693pjb.4;
        Tue, 26 Nov 2019 12:55:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UzzqAT1LcCAaJEiyxrABxQvrRHONs/sbtQC0zuyulaM=;
        b=dosRBimdaOBXnQGfOHHAFDaVV4Qz8gxCtVmQBVYdCg5cF5lSR+wGJ5c7B7E05Y4b9B
         9u5WyFQRAF0LR6dYFokO/jVETyx104ZDIzkZIxlNPYTmUlVi/e4aYG9hKbrIB0ro++33
         rQpyuhKB37d2dWXDfkAPv+I/lThC9Sjg/L4vMNNSMRyUIjF8iFCopQIk9e+7SFOJyJOQ
         /33r8Rp37Q7jZSVT8x2FspvLeTAY/qGBQzPawK2hosEDT6xjkuHAT3tYNRx+n/DDlqen
         ffZ9aCoudJaWR3FQT8sk4+70/0Z402/rHgqnvoeqoOW2uquP+1JAgFYuMrQRPRzl46Pi
         nJtQ==
X-Gm-Message-State: APjAAAUWucg8HgaCSHOY5uQ9auls7wtMfDjVtU7Yk7AUQVomIl14bGLN
        Oj4j3S8cs8OF/u5kkJonAyA=
X-Google-Smtp-Source: APXvYqzOtyt5X9MqlDyi03M88GYbmVn2BnF7606Ugs3Ii+kUH3WM9WCM2KlMdHN6J9kIrTyRuS7xkg==
X-Received: by 2002:a17:90a:1b0e:: with SMTP id q14mr1414570pjq.132.1574801746894;
        Tue, 26 Nov 2019 12:55:46 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j21sm12924657pfa.58.2019.11.26.12.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:55:46 -0800 (PST)
Subject: Re: [PATCH v3 03/13] scsi: qla2xxx: Initialize free_work before
 flushing it
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com, Quinn Tran <qutran@marvell.com>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-4-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0e30f3d6-148d-28cf-7f55-8acc9599e1be@acm.org>
Date:   Tue, 26 Nov 2019 12:55:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125165702.1013-4-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> Target creation triggers a new BUG_ON introduced in in 4d43d395fed12
> ("workqueue: Try to catch flush_work() without INIT_WORK().").
> The BUG_ON reveals an attempt to flush free_work in qla24xx_do_nack_work
> before it's initialized in qlt_unreg_sess: [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

