Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE714C88D
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 11:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgA2KMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 05:12:31 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33200 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 05:12:31 -0500
Received: by mail-wr1-f41.google.com with SMTP id b6so19495836wrq.0;
        Wed, 29 Jan 2020 02:12:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bZNl3QUSC0FMfcPPPWWqrnao2QBojv3lR0t976hDnyI=;
        b=JnAgaEv1OmDCCc0AklSlbeMzV5qeY1xxcLaM6+gXIAnLYHKV9CQ8Hm0S3w1/4T+pvu
         cMqumU56aS5JStqajD8ZdRSAFdsh7v+n9YdBdPsFo1cghmMpYzowftO1xSSUUEiJ6MqX
         ndiWDWhKh4qzudjdeMMQVj7y0UmNacDfJ5P4qvVS5oZQyDODhMujq+3xIe0leoCkID3H
         Gi4uxYtZrLeRFp0nHI5dw290bUWoJRbtyTHimjp3DF9Q0nPpfEb4ZLxrFZjc89cPVsfd
         Vl38UaXDab3lJ+0IALUQb/gEsolZjmodB5delayL0kpWuRfKBdn7LFS4QiH71MhdGDca
         KJig==
X-Gm-Message-State: APjAAAU9CoN/OMVY8oK+PhDdA0PaRpotRpDg+iJQpdHdC3PY9xirJZLh
        7OFysusIF+4GoYYCbF4fzDo=
X-Google-Smtp-Source: APXvYqwNKe/pk9bvldrLRJdvIFIJ+Gzr8weZdit3VhnUIq/c4bHYeuttKAB9NgHWm7KAom3kuLaGog==
X-Received: by 2002:adf:f10b:: with SMTP id r11mr5936811wro.307.1580292749767;
        Wed, 29 Jan 2020 02:12:29 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id c9sm2205865wrq.44.2020.01.29.02.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 02:12:28 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:12:28 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v3 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200129101228.GH24244@dhcp22.suse.cz>
References: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Btw. please do not forget to update the man page as well.
Thanks!
-- 
Michal Hocko
SUSE Labs
