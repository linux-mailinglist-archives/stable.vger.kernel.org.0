Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917BC2D05B8
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 16:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgLFPjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 10:39:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36743 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgLFPjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 10:39:06 -0500
Received: from mail-ed1-f70.google.com ([209.85.208.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1klw7E-0008MD-Lb
        for stable@vger.kernel.org; Sun, 06 Dec 2020 15:38:24 +0000
Received: by mail-ed1-f70.google.com with SMTP id z20so4645652edl.21
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 07:38:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvECloquqr/i570JJzZe7SazU9koazo+4SsnNeGAZqM=;
        b=p4S9rqqirFIP0CaHPS3FQfqqdPbUkElsgsXMfZ4bBzXgdxWR5Yi954SAnKX2rj5sxb
         yQN3w5sUtgfB1JO7hzJwJabaHzdIA1M5dwcdXe0+/QRF/2GbpoQhm7wtilLOq3E+rJtp
         3rZ+3YTISJRtxuQwZLVRajsDW98+dlbSPMwyhw0UrU66c1UOFuG4kCp5ALwwpTPZEvC9
         G0wz5YQrDr6euNDdSDSVUPhnAH6jbHKi+qlup5XktSE4/mSNqz1D4ZxHF2nYaV3m8TtD
         /d7NA7Zd35YXgDLJbobjBOoPFRAjOc4Gb7VtYJQHQfNoWl3OVGggIXEnefintbqW+qmC
         CjOA==
X-Gm-Message-State: AOAM532LLmPC8opMyqcDaNGcfXtROBVvUjcdImnF08X3m4JsOEzNONLu
        emOtrfcsaV6RuGwmrHZrVg+Frwv317kz5q5puhrSDjqOaqNq8yHZmVE0M89AulZEyJNPQ8o+0aV
        vminOhbws2q6TlAfK4TnDY9FZT3JRWuXFDl2FoE1FaOstE8u+fw==
X-Received: by 2002:a17:906:6b88:: with SMTP id l8mr15585430ejr.482.1607269104418;
        Sun, 06 Dec 2020 07:38:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkpV4fkbJlHg6cLT5wysSD1xsemA8TGvf+E7WJW8gv8R5+K7JRdVMtH3CAkWsC1BSLCaqCfI9cI5fWwDtSH5Q=
X-Received: by 2002:a17:906:6b88:: with SMTP id l8mr15585418ejr.482.1607269104192;
 Sun, 06 Dec 2020 07:38:24 -0800 (PST)
MIME-Version: 1.0
References: <20201206122124.9718-1-vincent.guittot@linaro.org>
In-Reply-To: <20201206122124.9718-1-vincent.guittot@linaro.org>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Sun, 6 Dec 2020 12:37:48 -0300
Message-ID: <CAHD1Q_zvgukrTEBrr_LQvv0Jmv9vmpR-MWfVzg2JqyqhBRYgeQ@mail.gmail.com>
Subject: Re: [PATCH v5.4] sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     "# v4 . 16+" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ben Segall <bsegall@google.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks a lot Vincent and all involved, much appreciated!
