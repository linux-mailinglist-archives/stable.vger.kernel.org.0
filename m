Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1114B3AFC0
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 09:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388071AbfFJHeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 03:34:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39717 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388008AbfFJHeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 03:34:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so7079294wma.4;
        Mon, 10 Jun 2019 00:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ygvU1x9lmDjaXuQhn1lkxt1q+lvnnZhu6o98ZD/vbPI=;
        b=d4QUQPlQaGNzO9vSzGceHz3R3TUXITcbv/RfDmCB22JFlFPZBCK1b0ZkROLVIURi9o
         W+8dglGxEtnk/K5cxexzVqxXDB2krZw/IjaR6haaBf/1XcPlZ1Vv5y0Jwxw5hwHZ9nkw
         nE9G2IiSpfOGzkmEzSyKSj6f/kS1Ld1ZAjfBf9ZmEIAzIEv9uTgwouw95Lqois92HOtW
         Me0pHYjx0mfmddyCo/dvjbKWbWnOaGZbPJkQ0V7adPGLPWTPufdTsm/3lt7BHWtFHZGg
         cjYteRXHsJUk6efpnJyOQUrXwf0Uk09ay3fv2pTQo/UqpC8LcSdhNSq0gpGI1Z3Acm8r
         /8hA==
X-Gm-Message-State: APjAAAW/mNmLfBc2nv5BSZsUvQB8Xv3nn14eUwHnnWMJrBnOYzs+kY4O
        iJzdvO0WqMSVy1rQrLBYwpGcMnaQ
X-Google-Smtp-Source: APXvYqx5wwXFr5jhnSCTiGfkELoXrUU3YocGHjdskafuSH0rlbI4Nvm/cLrGFjX6pGMGuy0OrikvbQ==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr4618407wmc.22.1560152053037;
        Mon, 10 Jun 2019 00:34:13 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id o4sm8142395wmh.35.2019.06.10.00.34.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 00:34:11 -0700 (PDT)
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
From:   Jiri Slaby <jslaby@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
Date:   Mon, 10 Jun 2019 09:34:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190610073119.GB20470@kroah.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10. 06. 19, 9:31, Greg Kroah-Hartman wrote:
> On Mon, Jun 10, 2019 at 08:27:30AM +0200, Jiri Slaby wrote:
>> On 07. 06. 19, 17:39, Greg Kroah-Hartman wrote:
>>> From: Jonathan Corbet <corbet@lwn.net>
>>>
>>> commit 2404dad1f67f8917e30fc22a85e0dbcc85b99955 upstream.
>>>
>>> AutoReporter is going away; recent versions of sphinx emit a warning like:
>>>
>>>   Documentation/sphinx/kerneldoc.py:125:
>>>       RemovedInSphinx20Warning: AutodocReporter is now deprecated.
>>>       Use sphinx.util.docutils.switch_source_input() instead.
>>>
>>> Make the switch.  But switch_source_input() only showed up in 1.7, so we
>>> have to do ugly version checks to keep things working in older versions.
>>
>> Hi,
>>
>> this patch breaks our build of kernel-docs on 5.1.*:
>> https://build.opensuse.org/package/live_build_log/Kernel:stable/kernel-docs/standard/x86_64
>>
>> The error is:
>> [  250s] reST markup error:
>> [  250s]
>> /home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/linux-5.1/Documentation/gpu/i915.rst:403:
>> (SEVERE/4) Title level inconsistent:
>> [  250s]
>> [  250s] Global GTT Fence Handling
>> [  250s] ~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Reverting the patch from 5.1.* makes it work again.
>>
>> 5.2-rc3 (includes the patch) is OK:
>> https://build.opensuse.org/package/live_build_log/Kernel:HEAD/kernel-docs/standard/x86_64
>>
>> So 5.1.* must be missing something now.
> 
> Odd.  running 'make htmldocs' on 5.1 with these patches applied works
> for me here.
> 
> What version of sphinx are you using to build the package with?

From the log, it looks like 1.8.5 (it's tumbleweed):

$ osc rbl Kernel:stable/kernel-docs/standard/x86_64|grep -i sphinx
[   11s] cycle: python3-sphinx_rtd_theme -> python3-Sphinx
[   11s]   breaking dependency python3-Sphinx -> python3-sphinx_rtd_theme
[   32s] [226/263] cumulate python3-sphinxcontrib-websupport-1.1.0-1.2
[   32s] [239/263] cumulate python3-Sphinx-1.8.5-2.2
[   32s] [242/263] cumulate python3-sphinx_rtd_theme-0.4.1-1.3
[   72s]
python3-sphinxcontrib-websupport-1.1.0########################################
[   72s] python3-sphinx_rtd_theme-0.4.1-1.3
########################################
[   73s] python3-Sphinx-1.8.5-2.2
########################################
[   73s] update-alternatives: using /usr/bin/sphinx-apidoc-3.7 to
provide /usr/bin/sphinx-apidoc (sphinx-apidoc) in auto mode
[  101s] + patch -s -F0 -E -p1 --no-backup-if-mismatch -i
/home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/patches.kernel.org/5.1.8-055-docs-Fix-conf.py-for-Sphin-2.0.patch
[  101s] + patch -s -F0 -E -p1 --no-backup-if-mismatch -i
/home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/patches.kernel.org/5.1.8-057-doc-Cope-with-Sphinx-logging-deprecations.patch
[  102s]   SPHINX  htmldocs -->
file:///home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/linux-5.1/html/Documentation/output
[  103s] Running Sphinx v1.8.5

thanks,
-- 
js
suse labs
