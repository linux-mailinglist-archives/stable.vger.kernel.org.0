Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4364B3B7A5
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389178AbfFJOnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:43:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35909 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389075AbfFJOnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:43:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id u22so5448160pfm.3;
        Mon, 10 Jun 2019 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=etJoHJ/BhhfupcyUUlxbBGwS8e+iknV/xMLkmpUR/fI=;
        b=KRrXu+rcVNCDowUha1CJTApTE/HHAOn4tI+19tnePonRANPSyLGAuStfA2rOed9EpF
         7i1uLRnQNhqb3D+yA6yApYJ+Uv+aukgCpa99NMHwjO6PBjBbwLmnuh6kKK8C1qSI6Klg
         Vrqq27BrggpRxNCvKZ12iVEak1OMl8N/p9uvN+xqxC+1yFwNkL9EVDN84XxSqTIoP3U9
         mF1FKwSskgJmsUXBR77ErJr660A3UJDFQzudh85l3Rugjzo8XC26gY/bES9Rx70NJsIb
         F1JrWr8yOGBGHCvwwTXY4fXGNqIZJFYPAEmpWYTFpVWBVkjLyqSuzTp/D4V9RqhkWcqt
         lYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=etJoHJ/BhhfupcyUUlxbBGwS8e+iknV/xMLkmpUR/fI=;
        b=bL1SMSewBnrv3B/kbuFSCx/leBtFraauN20MdVZEyBp0kw7fC/uFyk01bx8l6BjSsF
         7hrjXM3L0ckBd+9hVQXOVUyXbXbbITYSCQYUKXIDO/IlTDtU0kkvbBsDtc25FL3ZlPOG
         eWj9HtS936sJ5kfQBzKZw7JD9rLe7Clq8BMOqjIkL55J9SmkvTFlk3QaFVrIF78MzJtT
         BhwzAGWU9r4ftkH0iWftcaKfzaE+Nwstsz08B/yc8kBskXxKE0Q6FxNnHViD4Nw+cfGl
         5CdErpYsGdL8aLrYKPDi0dxIHYsQpIrtoC+eCej8Gx2q6cwX5JwzVfx0DsxX2YH22aeT
         TK0A==
X-Gm-Message-State: APjAAAWtmmOx8kNn6zCSq+/SaMyJV6ma6ylvypaUJmRTeUwL7KAjzJ9o
        WfcEoY/R6MTO5WAUFbwWSvx6CDs9
X-Google-Smtp-Source: APXvYqy7HCjTNaYApBGOMmpEQJk1fdobkI9ODGhvPInVWISQrm42nlQC38VgvN/zAcOee8mKr1cGJw==
X-Received: by 2002:a63:4f5b:: with SMTP id p27mr8027284pgl.273.1560177832407;
        Mon, 10 Jun 2019 07:43:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v138sm7885582pfc.15.2019.06.10.07.43.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:43:51 -0700 (PDT)
Date:   Mon, 10 Jun 2019 07:43:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/51] 4.19.50-stable review
Message-ID: <20190610144351.GD7705@roeck-us.net>
References: <20190609164127.123076536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:41:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.50 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:08 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 351 pass: 351 fail: 0

Guenter
