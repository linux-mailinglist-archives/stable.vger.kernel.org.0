Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D887D34E
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfHACWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 22:22:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42165 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfHACWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 22:22:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so33139840pgb.9
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 19:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VGApvnL+84IFDtzaC/b0pQcbHk1jTuqYhc5Tn5vBdgU=;
        b=j/Fc8W6MJoHLdkMzsMWpHbLARefNyLSynZ15uLRRm3dG8muTTgdP55ZJc0GRhiCkm2
         iwuNJQJwAOvToFizQOfFuF6r//tJCIyrtUkHQjqzGn+9gARj1Ebn0LXjfVK5kivaVD6M
         3r5IObfbvhBtWh2g3T+4Z8xnJSKHfw0biIHC0JZDFt5qs8GnSLRhnwVW3zhwyzOvn2MW
         rhEuTQFYcF3sipzGiLrtcebIwSjUuS4rNId/j6ypHvbXX+WCbgUHQbSxYd/ueUHqfFC4
         kQl1Z7bEaiqMQt7bnmMAc0jpJ4vNyJ6e3Pfult1ODUmffQbOMVS8Pxtht1ZYjFq/XTCG
         a1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VGApvnL+84IFDtzaC/b0pQcbHk1jTuqYhc5Tn5vBdgU=;
        b=YBw4CQUoZGvxZyv0IsSJh1uCwTUYrN2MhrYJtO1OSIpscO4wUjPQ34yEgVvPe5igzr
         qF15KD7B44AJIBqbBq21HOODgBRDGJxpmVjcJkComQ3hQM6IA3nA2ykz/G266dbVv7AZ
         lgBvJad0aK2Hn4s3I4vC7Qvw3VsGirBM8WtctAW6jVeStxl2z9dUforqNDiXP1FQ0iGB
         miyUmeMdDY631ewvLhcREUBkYLotybYcQS3WHHycFqufDWrEiA8F7W7gFjJzJ8nLqJ1b
         X6K4IFN6j8J6Yjtynhm8SA2sbuahbwyNZEQlW0u8k8tQ9GCvc+Tm2A5O91IE80TP/IB6
         d/AA==
X-Gm-Message-State: APjAAAX2vpAkO5gKEzj76uVoy0tFq3WXl7S1igwE2ztD5X0fk2+p3UVZ
        9C/vcnwi5tTdCUXJwWOztuSxzA==
X-Google-Smtp-Source: APXvYqyh8+oCu9Z1ikfdobMfbJR53p6MLysG11YdBRZTuQI7KARw0HlrI43CIDq55rjxfIA+ar6Iaw==
X-Received: by 2002:a17:90a:24e4:: with SMTP id i91mr6206025pje.9.1564626151109;
        Wed, 31 Jul 2019 19:22:31 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id j1sm92904180pgl.12.2019.07.31.19.22.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 19:22:30 -0700 (PDT)
Date:   Thu, 1 Aug 2019 07:52:25 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mka@chromium.org, rafael.j.wysocki@intel.com,
        syzbot+de771ae9390dffed7266@syzkaller.appspotmail.com,
        ulf.hansson@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cpufreq: Add QoS requests for userspace
 constraints" failed to apply to 5.2-stable tree
Message-ID: <20190801022225.owe6y34rwlomwf5r@vireshk-i7>
References: <15645886047744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15645886047744@kroah.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 17:56, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Not sure why you tried to apply it to stable tree. This stuff got
merged in 5.3-rc1 window only and shouldn't be part of 5.2.

-- 
viresh
