Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A197E7659A
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfGZMYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:24:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40134 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 08:24:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so24728948pgj.7;
        Fri, 26 Jul 2019 05:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+R2zZKTl/YMcL4CXyg3nPB3Iu9dZMVGUmu1TMD4nDu0=;
        b=ZHvgA5Cc5eCPIL92mRAzQ1gEqZe8ZMFi8lmTht/c3LHn166zWQX6932lxfI+PN8YgC
         I7/Qr8Lj24IecL2R3cjEenALETPM3jorwTwI3aFWCAoucAVdWhiuO+dBoK3Y+MYjO1gZ
         kURABThySgUBaG/Tay+erbPorNJN7i4LjIR03nO6dWITbVj14Po0syjFd6jAqihPYJxI
         g03b4GvEzBOz4ovpOusen4ywpPdCAlPsTGAnu1s1dfL9ouEx4Ppf4McXJLUzN3tzHGaI
         yWHcj/q+mQ+vKC23e8+HyioAsKvcWWAhCfHBDiINWruqWdKEFsYCrEM2VQV7wSKCGuEk
         8S7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+R2zZKTl/YMcL4CXyg3nPB3Iu9dZMVGUmu1TMD4nDu0=;
        b=GTZO3gQ6dGV6Y8xPHEF2xwW34RiOAuh9BilboMu1JOUMHFAf0MYlZewufB9BqDDNlm
         SmeHzeTi3qdew0qWpiJrQpeqku1xubosxhrFmXONgKbXBxy5a/30o3XlXPu4IHmVaNGw
         vaFH6/94SI3x+P7KKhu6JZGbCq48n29hOJzcWli9KFv/wfMIjnocnD6DL/hFvw0JGxQ8
         8+eG2+DquE1J81r+lR5NElEGutjpz5sKwKRwT4OZjLJZAD1suUakOsRi323o4RY3KG7T
         T969yB+bBhSGSHo0/xr4TvQfQoUXvDwRDZx1Qy93jEyyJg1TdTrPIIEmwA958cG7zdMz
         b46Q==
X-Gm-Message-State: APjAAAVt9JD2BIWlygqlXzqR9yxWbUWOAETxV4LGZLsf5jKmBHTTTDXl
        hWQHilTWDSwoHbX0Wp4tqOs=
X-Google-Smtp-Source: APXvYqwumlAKT+dXFXJgAxWoO1XoW7OXhN+JnQTkJ7zioqz6TFBKDozZB9bkGsT1ld3mM5V4LyZazQ==
X-Received: by 2002:a63:f452:: with SMTP id p18mr65363864pgk.373.1564143848820;
        Fri, 26 Jul 2019 05:24:08 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id p20sm84741899pgj.47.2019.07.26.05.24.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 05:24:08 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:54:01 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190726122401.GB4348@bharath12345-Inspiron-5559>
References: <20190724191724.382593077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86_64 test system. No dmesg regressions.

Thank you
Bharath
