Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA343A0AF8
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfH1T7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 15:59:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36915 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1T7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 15:59:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id y9so474394pfl.4
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 12:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FI1G7s58t4a8DPIitqbM75HyTwxQQan449GTl6NZCeE=;
        b=NPge8gE3m5J5F9Q1sEyQBWW8x825wbIzT5tJyZf8FDpV9+w3Wmw5z3dGHM/G4CcTg6
         eTqtDTvYI/MDJZrhVDCUzIcGuZE6Bo9jfVASqb3uDB42E8EzH6Wj2ChjQnpmGWIV+a7k
         E+VQJjAS1BWbkNvxrDJlrSPUf5oJ76pc7o/tlDqh4pY8DehdrV1SgmqexL2sk1xRNnXX
         Bkj0/imhyMII29oHNXIDYfFv0SbnlKNP0Gz8bOJAfsC8Z6+9hJxxxJ+ZqN6DyF97Aq+a
         nOFmxqAdfJp8zqUY4D/8/nKaqNBntZgn4sqPRM4Zib5/98ZPpDTvLz4AwWMz9MFY1oZb
         2Fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=FI1G7s58t4a8DPIitqbM75HyTwxQQan449GTl6NZCeE=;
        b=gKsZvAlovMJCu08mH7fozHj/uVbqOzSCX9dKIDjMSW6BpXHuEOLF3zQ+MmXugcKTPn
         UnNi6vaq5rtuZLLs8PfeckVRoWafeZG0gl+pCILdYscLKeryN3GtPvjDAW0xSq+zU77y
         KBRUk9bgJY5AWaszeXKv5zdKSNfk5T/47naMgg7oKU49Gj0ygt9/IvWqFZDanGVR5JdS
         t/e1V43F5W6myBVnZiIFsMu/+AV3nQQmJX/VS6pIOaJBwJ4AtOnaOPCjRhi+7tLsUfWV
         Vr7hoXG5Oo0iEy7sZRD+lq3Y6TI34CZAST1+q9st+GOqNfJf1pEoBfCHqx8D6XcwoOq3
         HTLg==
X-Gm-Message-State: APjAAAUzpgB77Gg/WtF5to2XK0kjVFo+xTJdlssNK9V/zcI9Z72F4M3O
        sbDuR/rmoJEbV4yF3LoxVso=
X-Google-Smtp-Source: APXvYqzl3e5GIhbGXwYiJIOw4Ptrc4uvP3VnsEtzskIat36sEVLY4y2n6rwDZnVifIqN3uC6C+pC+Q==
X-Received: by 2002:a17:90a:c086:: with SMTP id o6mr6223724pjs.2.1567022360490;
        Wed, 28 Aug 2019 12:59:20 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id g14sm180165pfo.41.2019.08.28.12.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 12:59:19 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:59:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Patches potentially missing from stable releases
Message-ID: <20190828195917.GA3078@roeck-us.net>
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm>
 <20190827200151.GA19618@roeck-us.net>
 <20190827202901.GB1118@kroah.com>
 <20190827204841.GA21062@roeck-us.net>
 <20190828084107.GB29927@kroah.com>
 <1ff990c8-3ea8-5f8b-78b6-d1d91da9e508@roeck-us.net>
 <20190828145443.GA7974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828145443.GA7974@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 04:54:43PM +0200, Greg Kroah-Hartman wrote:
> 
> I'm not saying it would be 30 minutes "from scratch", as I already have
> most of this all working already as I am doing this today for the syzbot
> stuff:
> 	https://github.com/gregkh/gregkh-linux/blob/master/scripts/syzbot_search
> 
> A "real" script would be wonderful to have, thanks!
> 

My script is a bit more fancy. It uses sqlite databases to keep track of
commits.

	https://github.com/groeck/findmissing.git

The initial setup takes a while, but subsequent runs are decently fast.
Example use: Run "./setup.sh" followed by "./missing.py 5.2" to get:

Checking branch linux-5.2.y
SHA 5319277968c1 [025bf37725f1] ('gpio: Fix return value mismatch of function gpiod_get_from_of_node()')
  fixed by upstream commit 2a6fc3cb5cb6
  Fix may be missing from linux-5.2.y; trying to apply it results in conflicts/errors
SHA b942dcdab8d1 [bd293d071ffe] ('dm bufio: fix deadlock with loop device')
  fixed by upstream commit cf3591ef8329
  Fix is missing from linux-5.2.y and applies cleanly
SHA 7c0044c1eec3 [d35661fcf95d] ('selftests/bpf: add wrapper scripts for test_xdp_vlan.sh')
  fixed by upstream commit 3035bb72ee47
  Fix is missing from linux-5.2.y and applies cleanly
SHA 60956b018bfe [883a2a80f79c] ('Input: elantech - enable SMBus on new (2018+) systems')
  fixed by upstream commit f3b5720cabaf
  Fix is missing from linux-5.2.y and applies cleanly

which seems about right.

Guenter
