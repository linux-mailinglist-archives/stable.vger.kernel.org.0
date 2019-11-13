Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E194FB712
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 19:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMSN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 13:13:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45851 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMSN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 13:13:58 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so2164466pfn.12;
        Wed, 13 Nov 2019 10:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qt+wiKiu+ReQhJJjXbF+KMsmYJf80ApOlk+bZGeFKTc=;
        b=XkrDY2MoftE3aIk9kSWJVdiwEJX1C0WdUO4WoArntcfH8VKFaoq8wTCAPDfjA95e94
         tvHIjZCIe2RbvevDmaVAdM8uZFXnkKApOTbEQskJi/MUOz+HKyC6FWI156P3HpPnmoAA
         zzXOBKfTzWxOPs1hRvodqTShZFbpB1h/PaW1tnYl7ieSJk1GkPpJVRk7M4cNxypERohn
         tbdgHtd5CQ2eOSw0XKAgDk13OQN4utVnfmSEGLR3/aOFKhRrYu3Lda2xuzS/7FPqm+VD
         a3gV8DVcgpiDiyyng9gjjOKPgmg41woM8lmaCgEhI7CzFEXkxj2M7XnMqvoUctTP6s+o
         rypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qt+wiKiu+ReQhJJjXbF+KMsmYJf80ApOlk+bZGeFKTc=;
        b=VXfke2OMHcHpQPuFLZholzog94FbwaopdTJ5mntRLze2anhYdr/QzgHj0QghfLZ5pG
         mMZlfutS1chO5nE8FykOKttHEauLlrgOyPmi3FdCX4la63/I5fJZy9iojWUz3hKy0Nc4
         q+cU6/BlonK8+ahxkV8nrXLgX5DQTPls1m0h4bQyIJfnfceLIpkCoD5lT5/G+hLzRsC7
         T/M2IhLVsYcZzphvuYfl7o0iYl1BkPlUc1DUcsDKP/1Mj6DsSUvcN28v8Uv0wr8ErCv/
         V7WMde//xYUq/iLtwuRNYt3xCJB/RR6yX9MVgr9a1CoFxUGBjdO5L2zpFqAICl5EB0cH
         UW5A==
X-Gm-Message-State: APjAAAX4nXVb50RM5WgjkPI4hnIgmFuTbrqdE19rnoqlBXLeUaYrIwwd
        lFkWJxeg3JU+xaP5mOl51qlyg7Qd
X-Google-Smtp-Source: APXvYqwqti63K193EV6HigXkeOshcX3DBUF3TPvbgS/coFk+n8X3EYmqrVOs7VIpkmtlEd6uTroMqA==
X-Received: by 2002:a62:fcd2:: with SMTP id e201mr921574pfh.52.1573668837485;
        Wed, 13 Nov 2019 10:13:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 6sm3651248pfy.43.2019.11.13.10.13.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Nov 2019 10:13:56 -0800 (PST)
Date:   Wed, 13 Nov 2019 10:13:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/25] 3.16.77-rc1 review
Message-ID: <20191113181354.GA19912@roeck-us.net>
References: <lsq.1573602477.548403712@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 11:47:57PM +0000, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.77 release.
> There are 25 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Nov 15 00:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
