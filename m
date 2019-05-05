Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA013F1D
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 13:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfEELMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 07:12:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42550 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEELMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 07:12:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id x15so4909885pln.9;
        Sun, 05 May 2019 04:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l0zmgdoj8M+BY5DwU3WfgU5GORSoWJsNn4NA2YBxR/Q=;
        b=SCGqAZOvSKXjT2c98rSNgM//BunywyXwz5nS/B0vZa43jQmLmWZPfUDZ+pb+99LXo4
         kibTB4bIkiqz+zzBvw3M3mLm07ydKi+L0Xq2RMzhz2w25xjhPuEOaE58pc14x08iy1F3
         Xv/56dpDEGmGtqPJakGifyobhMMySXBz9xcOuigqm3pTtbTTS/MU6Fls57LacvGtYTg6
         Q9ltJvuLz1ey+Wuvwe6tf/epP+YDxWSGZughjs2Z6Ax+dzelBKlsYDAqnLMJtIEb4ikN
         rz82MzyXCK0sU4mfQAsdm0wKqkBsv7cRCliIY3qT4tXHm0rGxdNSH/SGMnlXjwKxamMk
         gmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l0zmgdoj8M+BY5DwU3WfgU5GORSoWJsNn4NA2YBxR/Q=;
        b=GIaIG2x+JyAE4zGVFp8e32iCHfpxhPTF7WqK8V/FRUXG/0eCse+fv5Ph15JU73on9n
         V4gKH4u9ZErqF5hOY1t3u7HZEiFglK0zjM13V4fvzfp3R1i/p/3tDYfz0hDzNQRl6HSY
         appbBJFfAgXcL0ChZc2CmffATCbF/IxSRuKhM2rDh43MQR+nHUeAOS+106PVCg+J7QAQ
         EaGZVOosngiUp+UOnrzFGXOXskE3psky0Sb7n1eQ3WVnRoJx0zX4vbg1G6VlkMe208Vc
         NfbB43fpQ5XgaDLgg82XAqWvCDrBNEBzl/Ss4C+5CbVTwnaeZO/cy/zSGhf7zuQprnzQ
         Dtzg==
X-Gm-Message-State: APjAAAUrc5Pu88+Ha/zYXa29dzNHaI/zahTCMG5GZ+71TZ2XgFbjErXO
        8Th/RSxA0U/qC4tkIpD2ik4=
X-Google-Smtp-Source: APXvYqytGxE+nAYysxK2E4UcyLyqg4EMteDy1HvKjSBeLPRwZCbcfxRcKFGRFTf+U4LOd/8OMCE/CQ==
X-Received: by 2002:a17:902:e683:: with SMTP id cn3mr24095935plb.115.1557054774245;
        Sun, 05 May 2019 04:12:54 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id u19sm7674221pgn.49.2019.05.05.04.12.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:12:53 -0700 (PDT)
Date:   Sun, 5 May 2019 16:42:46 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
Message-ID: <20190505111246.GA3429@bharath12345-Inspiron-5559>
References: <20190504102451.512405835@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86_64 machine. No dmesg regressions observed.

Thanks
Bharath
