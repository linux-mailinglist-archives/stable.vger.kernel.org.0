Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388723DF5CB
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhHCThq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbhHCThp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:37:45 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0F3C061757;
        Tue,  3 Aug 2021 12:37:33 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so21821605oti.0;
        Tue, 03 Aug 2021 12:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dw8vPvoOreQ3B9Mw3U4vAaZi6IQVc+83CpWZ+viSeBY=;
        b=JTxKR+mP/FqNoruMUZqT8TlGif8shimBxTf2UGp6m2ttEIOChVjaCJuRsmgweYi+MJ
         n3OcG6BWiIc4h9p49VzyTXQ3HV3tv6Ph6l9c7U4CxEFQqPd7jqb9xu6P4sin60ybRcJ3
         WwBkoCqWzjkiwDuWwBAMCHDzK7iy6Kza6gb1iie2P4qPAZBZ8HZGCwygZyB13RiN2Lux
         hFSPptbCEXA/5xOzFJGNBkcfsAY5JG3i/eT4m5SJtVl/IbU5iEutKAO+Zj4ScAxchnhy
         3avpQZuEyrx0oG6o2cQzic/B9yIj9mGKOifBthvJPG6UcC/wuHaRCeuRqgCB1a/TGXAH
         pN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dw8vPvoOreQ3B9Mw3U4vAaZi6IQVc+83CpWZ+viSeBY=;
        b=qxYqm6zGIpUFuGq9XKCvv5eMaqs+FAAdyQUfuA+EdJ0UKPVw2vMFY3Xtr99R7AcsOg
         InPkPoJpPxGU7mEAUrYgzPYTeR7yXJ5oQzmQzF5geDfVz6VfCdOoj4pRvm08RyZM3wDK
         y1VaHtwUVScf0vdICiZkzVLtRJO3oHHC5hYPvIioXvBgmq33hTRta1nsSxtwGEZ56p72
         7XJrVmP+CVWxErMp1Jy3XmKezJA60ZOCs4c9Wc0X/YHOd4ahXiYpD3b7rb8bHybrAeyR
         NmUYoo8b5aJk7N1oaMLqE+9AEGp+fr0iu6qs4HDEHXYkyHkwwIa8j66ym/PDBA/J6JEi
         468Q==
X-Gm-Message-State: AOAM532ucftzVdt3ukJzxwIigwIad7F97qTXNdGGAK7zleDxruJNbUdA
        d3UFzA2G2YZp4gMe0+2BFcLDQK184x0=
X-Google-Smtp-Source: ABdhPJyxe9dJHa9J+OhOutrdhPllkFuMBHsUvmOAun+H42m0ib2yo8oyW8xmWn3IZKccwJ10VSQOow==
X-Received: by 2002:a05:6830:1e58:: with SMTP id e24mr16357169otj.115.1628019452830;
        Tue, 03 Aug 2021 12:37:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o101sm2619169ota.61.2021.08.03.12.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:37:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c1d12ff5-06d5-075c-e01f-5184ffb09e69@roeck-us.net>
Date:   Tue, 3 Aug 2021 12:37:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803192607.GA14540@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/21 12:26 PM, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 5.10.56 release.
>> There are 67 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> Not sure what went wrong, but 50 or so patches disappeared from the queue:
> 
> 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
> 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessary inode logging during link and rename
> 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors on awaiting already signaled fences"
> b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
> 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
> 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
> sk into newly allocated nskb
> 
> Best regards,
> 									Pavel
> 

FWIW, the git repository matches the shortlog and summary.

Guenter

>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 5.10.56-rc1
>>
>> Oleksij Rempel <linux@rempel-privat.de>
>>      can: j1939: j1939_session_deactivate(): clarify lifetime of session object
>>
>> Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
>>      i40e: Add additional info to PHY type error
>>
>> Arnaldo Carvalho de Melo <acme@redhat.com>
>>      Revert "perf map: Fix dso->nsinfo refcounting"
>>
>> Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>      powerpc/pseries: Fix regression while building external modules
>>
>> Steve French <stfrench@microsoft.com>
>>      SMB3: fix readpage for large swap cache
>>
>> Daniel Borkmann <daniel@iogearbox.net>
>>      bpf: Fix pointer arithmetic mask tightening under state pruning
>>
>> Lorenz Bauer <lmb@cloudflare.com>
>>      bpf: verifier: Allocate idmap scratch in verifier env
>>
>> Daniel Borkmann <daniel@iogearbox.net>
>>      bpf: Remove superfluous aux sanitation on subprog rejection
>>
>> Daniel Borkmann <daniel@iogearbox.net>
>>      bpf: Fix leakage due to insufficient speculative store bypass mitigation
>>
>> Daniel Borkmann <daniel@iogearbox.net>
>>      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
>>
>> Dan Carpenter <dan.carpenter@oracle.com>
>>      can: hi311x: fix a signedness bug in hi3110_cmd()
>>
>> Wang Hai <wanghai38@huawei.com>
>>      sis900: Fix missing pci_disable_device() in probe and remove
>>
>> Wang Hai <wanghai38@huawei.com>
>>      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
>>
>> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>      sctp: fix return value check in __sctp_rcv_asconf_lookup
>>
>> Dima Chumak <dchumak@nvidia.com>
>>      net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
>>
>> Maor Gottlieb <maorg@nvidia.com>
>>      net/mlx5: Fix flow table chaining
>>
>> Cong Wang <cong.wang@bytedance.com>
>>      skmsg: Make sk_psock_destroy() static
>>
>> Bjorn Andersson <bjorn.andersson@linaro.org>
>>      drm/msm/dp: Initialize the INTF_CONFIG register
>>
>> Robert Foss <robert.foss@linaro.org>
>>      drm/msm/dpu: Fix sm8250_mdp register length
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      net: llc: fix skb_over_panic
>>
>> Vitaly Kuznetsov <vkuznets@redhat.com>
>>      KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access
>>
>> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>>      mlx4: Fix missing error code in mlx4_load_one()
>>
>> Geetha sowjanya <gakula@marvell.com>
>>      octeontx2-pf: Fix interface down flag on error
>>
>> Xin Long <lucien.xin@gmail.com>
>>      tipc: do not write skb_shinfo frags when doing decrytion
>>
>> Shannon Nelson <snelson@pensando.io>
>>      ionic: count csum_none when offload enabled
>>
>> Shannon Nelson <snelson@pensando.io>
>>      ionic: fix up dim accounting for tx and rx
>>
>> Shannon Nelson <snelson@pensando.io>
>>      ionic: remove intr coalesce update from napi
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      net: qrtr: fix memory leaks
>>
>> Gilad Naaman <gnaaman@drivenets.com>
>>      net: Set true network header for ECN decapsulation
>>
>> Hoang Le <hoang.h.le@dektech.com.au>
>>      tipc: fix sleeping in tipc accept routine
>>
>> Xin Long <lucien.xin@gmail.com>
>>      tipc: fix implicit-connect for SYN+
>>
>> Jedrzej Jagielski <jedrzej.jagielski@intel.com>
>>      i40e: Fix log TC creation failure when max num of queues is exceeded
>>
>> Jedrzej Jagielski <jedrzej.jagielski@intel.com>
>>      i40e: Fix queue-to-TC mapping on Tx
>>
>> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>      i40e: Fix firmware LLDP agent related warning
>>
>> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>      i40e: Fix logic of disabling queues
>>
>> Pablo Neira Ayuso <pablo@netfilter.org>
>>      netfilter: nft_nat: allow to specify layer 4 protocol NAT only
>>
>> Florian Westphal <fw@strlen.de>
>>      netfilter: conntrack: adjust stop timestamp to real expiry value
>>
>> Felix Fietkau <nbd@nbd.name>
>>      mac80211: fix enabling 4-address mode on a sta vif after assoc
>>
>> Lorenz Bauer <lmb@cloudflare.com>
>>      bpf: Fix OOB read when printing XDP link fdinfo
>>
>> Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
>>      RDMA/bnxt_re: Fix stats counters
>>
>> Nguyen Dinh Phi <phind.uet@gmail.com>
>>      cfg80211: Fix possible memory leak in function cfg80211_bss_update
>>
>> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>      nfc: nfcsim: fix use after free during module unload
>>
>> Tejun Heo <tj@kernel.org>
>>      blk-iocost: fix operation ordering in iocg_wake_fn()
>>
>> Jiri Kosina <jkosina@suse.cz>
>>      drm/amdgpu: Fix resource leak on probe error path
>>
>> Jiri Kosina <jkosina@suse.cz>
>>      drm/amdgpu: Avoid printing of stack contents on firmware load error
>>
>> Dale Zhao <dale.zhao@amd.com>
>>      drm/amd/display: ensure dentist display clock update finished in DCN20
>>
>> Paul Jakma <paul@jakma.org>
>>      NIU: fix incorrect error return, missed in previous revert
>>
>> Jason Gerecke <killertofu@gmail.com>
>>      HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT
>>
>> Mike Rapoport <rppt@kernel.org>
>>      alpha: register early reserved memory in memblock
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      can: esd_usb2: fix memory leak
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      can: ems_usb: fix memory leak
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      can: usb_8dev: fix memory leak
>>
>> Pavel Skripkin <paskripkin@gmail.com>
>>      can: mcba_usb_start(): add missing urb->transfer_dma initialization
>>
>> Stephane Grosjean <s.grosjean@peak-system.com>
>>      can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values
>>
>> Ziyang Xuan <william.xuanziyang@huawei.com>
>>      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF
>>
>> Zhang Changzhong <zhangchangzhong@huawei.com>
>>      can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms
>>
>> Junxiao Bi <junxiao.bi@oracle.com>
>>      ocfs2: issue zeroout to EOF blocks
>>
>> Junxiao Bi <junxiao.bi@oracle.com>
>>      ocfs2: fix zero out valid data
>>
>> Paolo Bonzini <pbonzini@redhat.com>
>>      KVM: add missing compat KVM_CLEAR_DIRTY_LOG
>>
>> Juergen Gross <jgross@suse.com>
>>      x86/kvm: fix vcpu-id indexed array sizes
>>
>> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>>      ACPI: DPTF: Fix reading of attributes
>>
>> Hui Wang <hui.wang@canonical.com>
>>      Revert "ACPI: resources: Add checks for ACPI IRQ override"
>>
>> Goldwyn Rodrigues <rgoldwyn@suse.de>
>>      btrfs: mark compressed range uptodate only if all bio succeed
>>
>> Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>>      btrfs: fix rw device counting in __btrfs_free_extra_devids
>>
>> Linus Torvalds <torvalds@linux-foundation.org>
>>      pipe: make pipe writes always wake up readers
>>
>> Jan Kiszka <jan.kiszka@siemens.com>
>>      x86/asm: Ensure asm/proto.h can be included stand-alone
>>
>> Yang Yingliang <yangyingliang@huawei.com>
>>      io_uring: fix null-ptr-deref in io_sq_offload_start()
> 

