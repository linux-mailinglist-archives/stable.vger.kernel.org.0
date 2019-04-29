Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3D4E2EA
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfD2Mms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:42:48 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38481 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfD2Mms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 08:42:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id t20so8448965otl.5
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 05:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vEogRoT8pZodkxoqiae58S4xZW4gYagtPS9hzu/ehgY=;
        b=gQcMcOgj9fPEBzfRTI9gjw8d0xCxPufRjXAMqvnGW3ULNNGyvBcXTkMtxFHDTOrD9S
         WRfPx5JpZbbEGSo8ecaqcmKvKG7Ej7FCbQJBj/d14ABQQWHfLCAMJ0LW227B9VTEqOL0
         YwW5dsqmQy3flImGjE6xHplWPHhUAY12SL3veRyFMANfBJ5pK85TQivFSQ0sAtr2Qpy9
         jyZV4dMDiQQhJxF9vSxU62ny3VHDFtXeEx7NLHvDxJshnkC9UhpxJmp25ZKSrBmIJSNg
         AioTjICFyAxHrBNqrolLj+Q1lAgvQwa6cPmlEoLvPbx675nGzWcq/oQAOvJQgJpLPTb/
         pZkA==
X-Gm-Message-State: APjAAAUWAcD9X+LXf2kq2I997kqNf/bXafsjmSV2TV0jopTK6nVKxF5t
        Zg7+wgjP9Ju5xnHviqE2/agUg/KZyPg=
X-Google-Smtp-Source: APXvYqzWvOLy0lf6ez1UsxwsUQshffqxBSmq1gk/ScWVIOPH9dP+nfRKA+A1HNHVjP/ycRByewu0sA==
X-Received: by 2002:a9d:6355:: with SMTP id y21mr95164otk.354.1556541767472;
        Mon, 29 Apr 2019 05:42:47 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id i17sm13569308otr.36.2019.04.29.05.42.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 05:42:47 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Stable_queue=3a_queue-5=2e0?=
To:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.25B0CF6A1D.51E5TGYFCX@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 xsFNBFV5x88BEACoiLq9ZLmFvX3SCKyOJgwB4y+O65ElEkhL/RZx5QeFgKqaHOmKpUtgesP7
 by49i3uQdkwAdYaZNvOdUCPQ/Fb60aoOJX2TZ6UNqgtAG99MwMsIIZF3KeMFHwPdS5zEufEq
 9OThPOZuF1UKVw1tVQCds4Y5fX/b8ag1ixy+N4VtCqNfFq5GNCmgiQ2UFMa3+25pvyLwAu63
 BNO5IO1Ki8e7qnQRY/oRNhwWCf+vPkmeK0ozW+oR6PAB+WFGQH9KDdGPNtj4iEOoSCe4Jxy4
 J9VcwBPHVXqpRHB0JFag0fyNvW6D16IYw/lBa8oMDJRTdfN052A8+BFRnHug24etRIwewsUh
 aKjb4a6u3/qkPAMAawXeXSoCHl29Z/5UaitkyVJt/2H7sYzATK1xvSpXqF/UWXGe87K0U0P3
 gK+j0h8dwFyH7fW3w7kUaxnpnmAfGfdpuVYAqgnwKzdQfIcIVC5P24CsWeAAYBbalrgAHY9I
 yikIa6kJKXzOQv9EpKEMK3eJwi5amxgE3uD7+IHX5Z5E5TqeuqEZrUC/PFll8YIGy/ILeDZM
 NDNFJLYvvz/7DjlFBsT9Q5xUnS5OScsxq6R+4mhcRttXvg9LCLN3s6Z0qMzEKxupjmEyZbwN
 zRUB1wqJWpRcAmXptoigcOjFu/JBMTAnJ5ZaTjeBcC25e7bb5wARAQABzShNYWpvciBIYXlk
 ZW4gKFBlcnNvbmFsKSA8bWFqb3JAbWh0eC5uZXQ+wsF6BBMBAgAkAhsDAh4BAheABQsJCAcD
 BRUKCQgLBRYCAwEABQJVeckjAhkBAAoJEHNwUeDBAR+xL1cP+wfsrbLSXL/KF5ur2ehFz6WE
 tOf9ygRlkSezs4Ufppxjr8lgmOR71tkuz6TX3rpRzHwLF+DkT1tG5bGhHf1st7n5GUzFyGrU
 7VubWfaApEx/u17xvWwfOb44ZuwkseLO5HzzHhU5jaqhGOX5JsNuZi6S+LfOf5t0NKw5vTva
 UiqGGnwYAHRrTz19WBJrppz89c3Kh1Km+xjaePZfO8FCcPaEhzahXbtXFFIENbw+giGaxWVN
 dXbujOk0D/UrvyF5N7/MK4rI1q8DKBI94OBrC8poyLp5LQNed8iyx0lo7hY5COxr8f8xv1v2
 qjutwXZpMxMq6I8Q2chQy4YJD/eotd2rHm5lJlLOYU7KPD6vRlMJEVQSnqOpzevEuatefal3
 coZ3Ldtwjo8HuVsxEZwc839UsyQeNm59X4FP/RY7Zhns7e7xMQ0tKFy4mvnkyRmizP/G/Xsc
 lRvzmt/MOGw74zeGv7yKaFBCof8uaQAkXYIyioaxYTOF1w/Z9iReKQTTgnVCComhfURoECf7
 7VQo6kJbwWNBv3KTaCMM8Pd71yfq9/hhOQhE1LrlVkWn1P9M1ay9soAewR59e/AvtNe6lQVy
 7Cz3PER6dgR5ouW4SBfeEPo86hHGR/utJg9WnheH+QJkDXij04/+lf2YKpw7cMA4SjSz7/tg
 0adrQIeZFWXJzsFNBFV5x88BEADWSFeq9wV9weO8Xsata9VMCsnRljFLlTWZvOY26HM7dPXs
 4rzofzRTXN6KHUxR52RpAfcIImNHu34ZnpKA8Sd+4zwSN+oGkR/gcT6wyQNLDeZjq8GBPL7+
 rtSM3Jg/LO6tGTSCSOzioyhfY+FwMxn0JrUd2olVJBNBR+vXQiHcgDMabmov3AYmoJA3eF1u
 VuccJclRr/sbFmRiAxLWbKwnTiMmMkcTUBW/LSi3p1K8F9xcBREosIEiYn0f8wSScqSd3Fy1
 n/46GxL+NfLPm2ped5AcV0iDS7NX5QcsZ5y6HmNqdcKsQ3aCvRYjCZthEs2mFYlwHA82T1nD
 PQgCHErkF2utZnoiq1Pgl37tHnQf7Sf0UJ/9n1fF9skKmfB9yhDCWSze39yhiBAHQK5UFfM2
 A8MEdiAeNEsMYWLcrFhpPvvCMdb1JARzJerhni4p98MXdBHdGUoDBcLVLyktvu+iCtU59PpT
 CbIqsfyDBfmJwcW/8ioD2QBaIOxclbFd7TpNCs058QDGV38v6px79Fae5t19ZfsDQjQsd+r/
 eKX/aM9l5R9sookJX6qF9nDviOyCuddZ+qVkTuRuM2eb1J/ikmRFwBclbqnfrmamqcvRUyeP
 fGTPoFCgBEKba0d1V3734KDHxQGlvfgXI3GhWQY5t+WSRrTk48ipyPmZriqeQQARAQABwsFf
 BBgBAgAJBQJVecfPAhsMAAoJEHNwUeDBAR+xYesP/RlLkO542hKoCPQ7vj/4iiKlbB+n0Uic
 Pk9gWZpGA67kxCqJVQv61T3LCBkePSEA5YXe6hc1ttGOG/kgT6cjAlOw1gQAt53EqVj1yuXl
 f7W/8m/DLw0SA7MXwqkp4fj+A3Sfy8QMIp7z8TXOZMaeDOoM+DdqG3CI9YJSleHDNqQ9f3b7
 vQokgM1yrzIrYQr62Giaaq0XMJA0TfRbza3I952h4nBcRZ/IaYEhineCJd/8lGDEPRBeF0HE
 zrTQk7JUle4ZFCA60eF72yY5GWQWTr736DU2lX+VzmyJKU5NcCLUV7jJtYzN8uqNzKSwICRe
 1dsjlcQmbjRT50KqmXJW73SUy16T5tYaLdKQ0y2C1iwfECMXcR5imCeTZj+fyB71K3aKb46y
 Sqze5WG2VZiCG5Q9DCkuIjt9tB7olNugLYxe/e/rKq2xRaZaq7hIpSihA5xuyxrnnKfp0kLk
 e2s395+Pj8ROBak+QNjQ7XHJvGYWkpfi5inUVtYC2IQ3Pe0U7mIKGvB+73N6BxVaVgbFIKMz
 LPZBkAja0BUdBqD2L/VubSxf+Zu+F1azwDDpw1xvmQ2UpM4OzXkLlVromiZjEUP6BdhP1Q6u
 BEEub1tT1RvyUxlFZsc9b51KHic/nMUqldFTxxCUvfe1aGqvfkWRgZsKViZ6Nt/x9faLQdT4 UNdR
Message-ID: <9b9124c8-faa1-5d31-0e7a-3b7c59d18b28@redhat.com>
Date:   Mon, 29 Apr 2019 07:42:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cki.25B0CF6A1D.51E5TGYFCX@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/19 7:38 AM, CKI Project wrote:
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: d3da1f09fff2 - Linux 5.0.10
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
> 
> We attempted to compile the kernel for multiple architectures, but the compile
> failed on one or more architectures:
> 
>              s390x: FAILED (see build-s390x.log.xz attachment)
> 

We took another look at this one and the failure seems to be valid after retrying the build. The same issue cropped up both times:

> 00:02:54   CC [M]  drivers/infiniband/core/uverbs_cmd.o
> 00:02:54 In file included from ./arch/s390/include/asm/page.h:180,
> 00:02:54                  from ./arch/s390/include/asm/thread_info.h:26,
> 00:02:54                  from ./include/linux/thread_info.h:38,
> 00:02:54                  from ./arch/s390/include/asm/preempt.h:6,
> 00:02:54                  from ./include/linux/preempt.h:78,
> 00:02:54                  from ./include/linux/spinlock.h:51,
> 00:02:54                  from ./include/linux/seqlock.h:36,
> 00:02:54                  from ./include/linux/time.h:6,
> 00:02:54                  from ./include/linux/stat.h:19,
> 00:02:54                  from ./include/linux/module.h:10,
> 00:02:54                  from drivers/infiniband/core/uverbs_main.c:37:
> 00:02:54 drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
> 00:02:54 drivers/infiniband/core/uverbs_main.c:897:28: error: 'struct vm_fault' has no member named 'vm_start'
> 00:02:54    vmf->page = ZERO_PAGE(vmf->vm_start);
> 00:02:54                             ^~
> 00:02:54 ./include/asm-generic/memory_model.h:54:40: note: in definition of macro '__pfn_to_page'
> 00:02:54  #define __pfn_to_page(pfn) (vmemmap + (pfn))
> 00:02:54                                         ^~~
> 00:02:54 ./arch/s390/include/asm/page.h:162:29: note: in expansion of macro '__pa'
> 00:02:54  #define virt_to_pfn(kaddr) (__pa(kaddr) >> PAGE_SHIFT)
> 00:02:54                              ^~~~
> 00:02:54 ./arch/s390/include/asm/page.h:166:41: note: in expansion of macro 'virt_to_pfn'
> 00:02:54  #define virt_to_page(kaddr) pfn_to_page(virt_to_pfn(kaddr))
> 00:02:54                                          ^~~~~~~~~~~
> 00:02:54 ./arch/s390/include/asm/pgtable.h:60:3: note: in expansion of macro 'virt_to_page'
> 00:02:54   (virt_to_page((void *)(empty_zero_page + \
> 00:02:54    ^~~~~~~~~~~~
> 00:02:54 drivers/infiniband/core/uverbs_main.c:897:15: note: in expansion of macro 'ZERO_PAGE'
> 00:02:54    vmf->page = ZERO_PAGE(vmf->vm_start);
> 00:02:54                ^~~~~~~~~
> 00:02:54 make[5]: *** [scripts/Makefile.build:277: drivers/infiniband/core/uverbs_main.o] Error 1
> 00:02:54 make[5]: *** Waiting for unfinished jobs....
We spotted this recently in mainline as well.

--
Major Hayden
