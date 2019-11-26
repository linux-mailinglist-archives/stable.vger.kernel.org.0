Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7110A5AA
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 21:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKZUzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 15:55:22 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36508 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 15:55:22 -0500
Received: by mail-pg1-f195.google.com with SMTP id k13so9616751pgh.3;
        Tue, 26 Nov 2019 12:55:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fd+09IorCIPtEgTvPZr5ANBerCHSTZCihmc7ysWdRDM=;
        b=KlJSAK+qAKa9PXMnTVa2RUKXCQ+GKiSLRx5XGn/GG06XpU0UeZ+20JW/tDtPw6SGwv
         hLU1fzbnGS/zoDVFiil8zgnk4NSYdv2wwgiigX7ZhvVo9x9XwtowcvR8kyKgtSUTdg7h
         sI5BQE24tWCONM+DgaIcPKA45Ros3bzB5XE1cLl0j6mF43aMCJJO5jk45KdVAZOWyElJ
         9nwQezjfx2fPowRwJW7yXfPSBpKvAiP5FwhR5ExaXI+dExmUY3X07nbKHbVnuHt/8T6u
         yOFfZt6iS7DpEgbkwm/wzvWbLzDNjADKP+cKRzUvNO/SzuI2x4KkDzI5wfr1/V/ettRM
         xnRw==
X-Gm-Message-State: APjAAAXxRT5tCw7+xnIvXN4BhucQ1ZRd4nO7mlridEs1xOfxgkZz9YTL
        VKUibNqjsgZfB37Aa3a53Oc=
X-Google-Smtp-Source: APXvYqzHeCluBcsXo0DBvdJiyxRX1MNr5CNHEyx57/oA6BWx31p24839eAllahDr1zOyRIl8OJ4MXg==
X-Received: by 2002:a63:774a:: with SMTP id s71mr522483pgc.57.1574801720025;
        Tue, 26 Nov 2019 12:55:20 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q13sm2819063pjc.4.2019.11.26.12.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:55:18 -0800 (PST)
Subject: Re: [PATCH v3 01/13] scsi: qla2xxx: Ignore NULL pointer in
 tcm_qla2xxx_free_mcmd
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com, Quinn Tran <qutran@marvell.com>,
        Thomas Abraham <tabraham@suse.com>, stable@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-2-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4c8131c4-6386-860c-6dfc-695eabeedcb4@acm.org>
Date:   Tue, 26 Nov 2019 12:55:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125165702.1013-2-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> If ABTS cannot be completed in target mode, the driver attempts to free [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
