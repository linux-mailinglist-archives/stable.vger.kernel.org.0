Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EFC4DDDD
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 01:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfFTXsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 19:48:43 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39642 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfFTXsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 19:48:42 -0400
Received: by mail-oi1-f196.google.com with SMTP id m202so3429413oig.6;
        Thu, 20 Jun 2019 16:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wostT3Xc6vu2lS2+SWXXzSbhD9zC9Wywuo64OXkYOLc=;
        b=EKGHlg8cAUQZeAi2Jf8Mo/MRrT8m9sebpd2zUUJvscKapxzf0ln60tD9Oe2vOLKaFR
         5s0sH2KCVJrBrjMm9wM1ZwcUmaKu5KO0hf0aj3OtKn4Z0CA12M2VW2mcMSMDUWqImqNe
         /qFgKa+SRNJf23eHC+PhL1brSHN73Ey+PC+XWT4p6SEixqvOcsUvGSJOGTN4M55FHEkT
         ezV1VueV2k2KhcnFuyYotNLS4J9JdHSAmaZzREQdO8kg6yli9ussLw6iaLWw5vXq/Z+0
         nGqT/pbDRvtau65QhCAp3vb4HhN8MbCetUZrpkuqNMLnrBXXnmZ4SMEHp2i0HfP1e3FY
         bCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wostT3Xc6vu2lS2+SWXXzSbhD9zC9Wywuo64OXkYOLc=;
        b=F2JPrNJiSz8h2RIag6oQQ0Ayta51fqnPqXbff5Q8J8OkKCLxR3iOsnGasZHyQYAinS
         TtLaWMjGVc6Lgd/ihBY4J5gYO0GPZ3rc21fu6SoPzCVN3aXrars0lm48nDblc8Agp43N
         QCEgscE4E+WnNWoLybu/6gP90S3aWs4RBZC8aC6wgIH1Y1KVBM5HvrZF8JTTs4Dh9+om
         JjGOpgr8id+zZu398FejWn7MtQQPFMKE2EmOB2vB2fhhVwDTxJTYB30klpS8bDVn9SFq
         QKzry4gBumf9WnZEGoabAIoBl9wekQn7RUzn21GkV9hAjGtu7M5olKMlogtuM8iLGP8s
         i1SQ==
X-Gm-Message-State: APjAAAU5sZsaMXTJs1Qh4cw8UZ7cJpg6stF6GKe0ThZ7msvIXJYhO4op
        vTY/ApjhhdaU646Sm1X83hvlcomC
X-Google-Smtp-Source: APXvYqwYgelUf7yAM/9GZho8zMHQoY6q5D+SzprHr/4MPNs0POG9dov6uqoqecIRJ5yILipuIWWtqQ==
X-Received: by 2002:aca:4806:: with SMTP id v6mr1000111oia.133.1561074521871;
        Thu, 20 Jun 2019 16:48:41 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::48])
        by smtp.gmail.com with ESMTPSA id v198sm486452oif.0.2019.06.20.16.48.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 16:48:41 -0700 (PDT)
Date:   Thu, 20 Jun 2019 18:48:40 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/98] 5.1.13-stable review
Message-ID: <20190620234839.4f4aiczjjssfn2fg@rYz3n>
References: <20190620174349.443386789@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 07:56:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.13 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Compiled and booted.  No regressions on x86_64.

THX

Jiunn
