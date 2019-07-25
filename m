Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4474675089
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfGYOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 10:05:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38513 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfGYOF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 10:05:27 -0400
Received: by mail-lf1-f67.google.com with SMTP id h28so34591325lfj.5
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 07:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d9/jZZ/wGnP4XWWrJc72aqLii2UTG2NwmOzZLmtfRTs=;
        b=p4Ymi9d4D9XehufPPYM3MBV2tV9cdOfbvGrKviwyG9mm1Fz+1Lhj/EvtnJFkUuvb/M
         Dvp3VSClPna6uot0vw3CeRe0QVO8nHL9jDc+8gLAiiBQvM7wdLspbW75YMB0Ww/+FeoV
         riLvHNfz3XNWziFaCqafOlGiHbZ0Wt8FWFrNdGMX/6luZQ0UWqicnNQSDQiFnMYKfVMe
         Gfo+VMlNlmk4dFTfWVf6LrsMH2+X73YQu0rSqumeYwVBUYgvjR4Za1ISnUUyAb2Lv9Iw
         fPNmxkEWtnjoJ9Q6vw24BrmrLRn6qsngmwjFse3wrINa4AjDAD6y/+5ZPIpTESFFGrhh
         7Pgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d9/jZZ/wGnP4XWWrJc72aqLii2UTG2NwmOzZLmtfRTs=;
        b=Gl03PRPhAS1lbGpIfgYpAOUEEpgTvLGNOxwcpSxWATbQ3t4/xGjWIhADEfgvSh+1fA
         +a9keIyqVxOgMc5lveHA6LN9m4zcsIFgpdAjlBuf7h2oJ0PKX3/jaAcDLHdALJByJXST
         C2tBA3E8VsdelYxl28efg/u8qDcplYlvnB/2LULBSA0wjDPqdWXBDOka1xI/b0xzZBrH
         X+t7nVu/LWlkv0gZUfG6pGZ8p3Ys5hdPW0+nXJ4N7aIInO0wkvq/xooBclVBRk7dD/bj
         sziKHG3s+BH+8Y2WqEz2z+treUEx4/WIfyIHwUmKpj51TFzgHvpf71LMb7LT1g851yRq
         0txg==
X-Gm-Message-State: APjAAAW2LSsDNi03Dc3xiki7DxEJm7Z1sezTdAu1e5xVqFL3GK6KS6cA
        IvUKmZnJJ6AUZTrLj0erSei0Lbtqsbc1k5viLJBt2j/Vk8c=
X-Google-Smtp-Source: APXvYqw49ekawAIJPp2WQWsuoc36ITRLiJynGhiqAqMikOBa1iHIBQHs/lNKNYo3CAFkg4pZfV1Z78Uez67ejwLDOic=
X-Received: by 2002:ac2:546a:: with SMTP id e10mr42095604lfn.75.1564063525132;
 Thu, 25 Jul 2019 07:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191735.096702571@linuxfoundation.org> <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com> <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
In-Reply-To: <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Jul 2019 19:35:13 +0530
Message-ID: <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        wanpengli@tencent.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, sean.j.christopherson@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo,

On Thu, 25 Jul 2019 at 19:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/07/19 13:34, Greg Kroah-Hartman wrote:
> > Any chance you can run 'git bisect' to find the offending patch?  Or
> > just try reverting a few, you can ignore the ppc ones, so that only
> > leaves you 7 different commits.
> >
> > Does this same test pass in 5.3-rc1?

Yes. same test pass on 5.3-rc1
kvm unit test always fetching master branch and at tip
runs the latest test code on all branches
mainline 5.3-rc1 and stable-rc-5.2 branch

>
> Anders, are you running the same kvm-unit-tests commit that passed for
> 5.2.2?  My suspicion is that your previous test didn't have this commit

No.
I see two extra test code commits for 5.2.3
Re-tested 5.2.2 with tip of kvm unit tests sources and vmx test FAILED [1].

Greg,
This investigation confirms it is a new test code failure on stable-rc 5.2.3

> since the symptoms match and the corresponding fix was made in 5.3.

Thanks for your findings.

> Paolo

- Naresh
[1] https://lkft.validation.linaro.org/scheduler/job/837811
