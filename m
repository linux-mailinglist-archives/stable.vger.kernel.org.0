Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091FD282F10
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 05:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgJEDai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 23:30:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:21932 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEDai (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 23:30:38 -0400
IronPort-SDR: u2DXX3hOevjbzdl6U1shz1E2XEWuIEednEVyDC/hkqcnBrR1GadDNknVtCkcmG0ShV39qV0QCk
 d3xRc9vIEhVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="163427683"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="163427683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:30:34 -0700
IronPort-SDR: wgZ/mIv7rzj/ovD+4S+MIid/eyJTwqehy3S7dVa69ROhLiD4lGc34CdoC0wkSWVEI2iU30n4U4
 yEUSS17pj6Vg==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="523307956"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:30:29 -0700
Date:   Mon, 5 Oct 2020 06:30:27 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-integrity@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
Message-ID: <20201005033027.GA144802@linux.intel.com>
References: <20201005002659.81588-3-jarkko.sakkinen@linux.intel.com>
 <202010051054.nSqmgsmE-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010051054.nSqmgsmE-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'll fix this this and send v2.

/Jarkko

On Mon, Oct 05, 2020 at 10:42:00AM +0800, kernel test robot wrote:
> Hi Jarkko,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on security/next-testing]
> [also build test WARNING on integrity/next-integrity char-misc/char-misc-testing linus/master v5.9-rc8 next-20201002]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Jarkko-Sakkinen/KEYS-trusted-Fix-incorrect-handling-of-tpm_get_random/20201005-092710
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-testing
> config: x86_64-randconfig-a002-20201005 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project bcd05599d0e53977a963799d6ee4f6e0bc21331b)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/ef36c0cd07555d658f81aee66abb02bdbe1c37b7
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Jarkko-Sakkinen/KEYS-trusted-Fix-incorrect-handling-of-tpm_get_random/20201005-092710
>         git checkout ef36c0cd07555d658f81aee66abb02bdbe1c37b7
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from security/keys/encrypted-keys/encrypted.c:22:
>    In file included from include/keys/trusted-type.h:12:
> >> include/linux/tpm.h:423:16: warning: no previous prototype for function 'tpm_transmit_cmd' [-Wmissing-prototypes]
>    extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
>                   ^
>    include/linux/tpm.h:423:8: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
>           ^
> >> include/linux/tpm.h:426:1: warning: non-void function does not return a value [-Wreturn-type]
>    }
>    ^
>    2 warnings generated.
> 
> vim +/tpm_transmit_cmd +423 include/linux/tpm.h
> 
>    397	
>    398	extern int tpm_is_tpm2(struct tpm_chip *chip);
>    399	extern __must_check int tpm_try_get_ops(struct tpm_chip *chip);
>    400	extern void tpm_put_ops(struct tpm_chip *chip);
>    401	extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
>    402					size_t min_rsp_body_length, const char *desc);
>    403	extern int tpm_pcr_read(struct tpm_chip *chip, u32 pcr_idx,
>    404				struct tpm_digest *digest);
>    405	extern int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
>    406				  struct tpm_digest *digests);
>    407	extern int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen);
>    408	extern int tpm_get_random(struct tpm_chip *chip, u8 *data, size_t max);
>    409	extern struct tpm_chip *tpm_default_chip(void);
>    410	void tpm2_flush_context(struct tpm_chip *chip, u32 handle);
>    411	#else
>    412	static inline int tpm_is_tpm2(struct tpm_chip *chip)
>    413	{
>    414		return -ENODEV;
>    415	}
>    416	static inline int tpm_try_get_ops(struct tpm_chip *chip)
>    417	{
>    418		return -ENODEV;
>    419	}
>    420	static inline void tpm_put_ops(struct tpm_chip *chip)
>    421	{
>    422	}
>  > 423	extern ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_buf *buf,
>    424					size_t min_rsp_body_length, const char *desc)
>    425	{
>  > 426	}
>    427	static inline int tpm_pcr_read(struct tpm_chip *chip, int pcr_idx,
>    428				       struct tpm_digest *digest)
>    429	{
>    430		return -ENODEV;
>    431	}
>    432	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


