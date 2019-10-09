Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA6AD04F7
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 03:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfJIBAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 21:00:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33059 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfJIBAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 21:00:43 -0400
Received: by mail-io1-f66.google.com with SMTP id z19so1267800ior.0
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 18:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=LJCDARiFiBLpdpxYJIryjnohhQYmgsyU7CX764JVeEA=;
        b=ASRaVdcnYAUi71S2QQYygps/Fckw/LI0/elZq3dsaiZDrTuC1cG19KBsKVUiVeNb44
         R6AJ1rbK3s50ZBbjib3L2pSpd0X8LC+/1U/lD3nlIQ/5SDyUIfiSHKvIPbo5+jfJ+idD
         ysFvFXo5Kz4a2jAPOsqWShmf39yyZk95PMEAMeilsw+8rFfpAirRlmVU2+EKzrerhpKI
         9V6H6r0lq5bliHaovUxZTLt+hg/Qnu1b/nFwOs361hFNPcUemQ2MmlltMnQaGpttLkjh
         7smbwrhshxCuGpwajmlmCZtAUUqTowQbe+HJs3plV8qr3kbHKiOi9Kbgi5OmPt+FAt7d
         tsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=LJCDARiFiBLpdpxYJIryjnohhQYmgsyU7CX764JVeEA=;
        b=Hsz9Z4mPuUe1n+W/7S07JGtXx61NmIpJ7htx4ccXVvyb9pxH0NH7IgrVYpf9ZVpoR5
         PVlY2/JHlzpiIGb/lRGcVdO7zd/ZLO/SuJltvX0Bcu2k7Bcn3adS/CNJJxQqyGCIacuk
         On7kIS3x+/YT9qWxIyk6jLpgbYv2x9JThJqr7F36AjI/dbpxI0G3IEbAAl7NIRh4kx43
         K29eIFG8ckp10MZHprBLF2gTkip739Bd83+HX9DbHJ6WsxLR8vxhjCR8Z3tAaH9do0MW
         /JAMlE3XCPdr1wWzmPrZ8tvaWoqImPkCjTHkC/CqVbF3PEk7RTgkL7DTA+Bx0jVc6RMs
         shiQ==
X-Gm-Message-State: APjAAAUbq2x6mzKACZBLCTcUG7jGEnYujEmoy8gNUSb090w5RTRyn2fX
        /sVMP5z8Ujd154k+ZS4QhxWaEA==
X-Google-Smtp-Source: APXvYqxSmPLVOUTb1rkthXBaScN1BKC9Tv8hRSvuzqu4A6/qmTI0qaQM0LNVTjnm6I+6BqAUGNpShQ==
X-Received: by 2002:a5d:9359:: with SMTP id i25mr1087359ioo.184.1570582842686;
        Tue, 08 Oct 2019 18:00:42 -0700 (PDT)
Received: from localhost ([64.62.168.194])
        by smtp.gmail.com with ESMTPSA id f189sm410708ilh.71.2019.10.08.18.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 18:00:42 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:00:36 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Sasha Levin <sashal@kernel.org>
cc:     gregkh@linuxfoundation.org, vincent.chen@sifive.com,
        david.abdurachmanov@sifive.com, palmer@sifive.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously
 enabled in" failed to apply to 5.3-stable tree
In-Reply-To: <20191009005252.GQ1396@sasha-vm>
Message-ID: <alpine.DEB.2.21.9999.1910081759550.972@viisi.sifive.com>
References: <1570555664182195@kroah.com> <20191009005252.GQ1396@sasha-vm>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Oct 2019, Sasha Levin wrote:

> I might be missing something here, but wasn't the label "1" already
> declared a few lines above?

See the "Local Labels" section of 

https://sourceware.org/binutils/docs-2.24/as/Symbol-Names.html#Symbol-Names


- Paul
