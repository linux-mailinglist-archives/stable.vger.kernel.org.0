Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F62D1234B6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLQSXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:23:12 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45627 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfLQSXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:23:12 -0500
Received: by mail-pg1-f182.google.com with SMTP id b9so6095990pgk.12
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 10:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=xXTjYBwKj1PourRikqjNAhACC2LSkztTv9/VLDlPPVQ=;
        b=JuqNcBloQnWyYBVoLiBwBWIdkw9gb96gZm1FfPVfeVCdqJSwpMp564fqBToc0Yo8ae
         z/lK6JC6LXKKyHZypdsyY3eauFmrtd9/+WEI++XNJwCIPBOeXdiJ01jYfiAFxoaZlTq4
         XMWbcwKzUEybh9ymVEnb1OtClsLIoeHPyXy2QkVslvQI6CU2lbWIZPhG5CSERuPFr3Z2
         GXWz5z01CFmjEbjD0KUeqEvEMCvp3T9ZCSXrL495RzUgyAOTbDHAKMh8snyP+CJXYa9G
         GTWooI50wua9lx70M7GZxMVG0in2L5BCYnmsq5cDJ1NFQ62eDGcQScexa4eCgV+Ogf4x
         RcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:content-transfer-encoding
         :user-agent;
        bh=xXTjYBwKj1PourRikqjNAhACC2LSkztTv9/VLDlPPVQ=;
        b=g3+17lygqp4WvAYs7EVJaXE3zzFS4jbkIiVL1u7i0bZZrl4D4zgbpnnXEyMeV5MwFi
         33Lh84lJ8Q4VnyLItECQE4S8aKBb/2LM62zu93anApZ0vT1b5w9C8KMjUoaEk99LZmFM
         AhKKZDhm82ox6Rp5rpycN8fxeo3beWXfbrpya1r4BF5Vr9OC0cDl6PQmGvdb8c7TwmJE
         a7esKUM5i9kDz4kpQ6KcYhf433DVldjmuJz4EcBUOF+GKrP8CdCOcNx7wYNzl/bhpY63
         7ldFWmy8WuScErSI1tnz67VuTq8C4/X0fDwZzj86J5mhEyPVaVzxzV+5SEpuuGoW8vQJ
         gM/A==
X-Gm-Message-State: APjAAAVROa1PwDJgGqzzfJHA95FxAv7jSe2yLqCtBhpcAcnSOJt9a69g
        yPZhjz9ExPKh+dfLLUG546jZijEz
X-Google-Smtp-Source: APXvYqzxw9fdx78Day3Ksf6MEHkVVlqV09Lz+VktfZD57SRA5nkkOuO9swDNNF4EQsrED2x/PR1KXw==
X-Received: by 2002:a63:6704:: with SMTP id b4mr27387232pgc.424.1576606991217;
        Tue, 17 Dec 2019 10:23:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ev11sm3784801pjb.1.2019.12.17.10.23.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:23:10 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:23:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Subject: 4.4.y/4.9.y stable queue build failures
Message-ID: <20191217182309.GA29679@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just in case this hasn't been reported already.

arch/powerpc/kernel/asm-offsets.c:30:0:
arch/powerpc/kernel/asm-offsets.c: In function ‘main’:
arch/powerpc/kernel/asm-offsets.c:401:37: error: expected specifier-qualifier-list before ‘vdso_data’

This affects all powerpc builds in v4.4.y / v4.9.y stable queues.

Guenter
